class Workout::Generator
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :user
  attribute :workout

  validates :user, :workout, presence: true

  def generate
    return false unless valid?

    chat = create_chat
    response = chat.ask(user_prompt)
    parse_and_create_exercises(response.content)
    true
  rescue RubyLLM::Error => e
    errors.add(:base, e.message)
    false
  rescue JSON::ParserError => e
    errors.add(:base, "Failed to parse AI response: #{e.message}")
    false
  end

  def swap_exercise(workout_exercise)
    chat = create_chat
    response = chat.ask(swap_prompt(workout_exercise))
    parse_swap_response(response.content, workout_exercise)
  rescue RubyLLM::Error, JSON::ParserError
    nil
  end

  private

  def create_chat
    chat = user.chats.create!(model: user.default_provider_model)
    chat.with_instructions(system_prompt)
    chat
  end

  def system_prompt
    rp_guide = File.read(Rails.root.join("guides", "rp_methodology.md"))
    equipment_guide = File.read(Rails.root.join("guides", "equipment_profiles.md"))

    <<~PROMPT
      You are an expert strength training coach following Renaissance Periodization (RP) methodology.

      #{rp_guide}

      #{equipment_guide}

      IMPORTANT RULES:
      - Always return valid JSON and nothing else
      - Select exercises appropriate for the specified location and equipment
      - Order exercises with compounds first, then isolations
      - Match volume to the mesocycle week and targets
      - Reference past performance data to suggest appropriate weights
      - Keep exercise selection consistent within a mesocycle when possible
    PROMPT
  end

  def user_prompt
    mesocycle = workout.mesocycle
    location = workout.location

    prompt = "Generate a #{location} workout for today. "
    prompt += "Target workout duration: #{workout.target_duration_minutes} minutes (including rest periods). Select exercises and set counts to fit this time frame. "

    if mesocycle
      prompt += "This is week #{mesocycle.current_week} of #{mesocycle.duration_weeks} in a #{mesocycle.split_type.humanize} mesocycle. "
      prompt += "Target RIR: #{mesocycle.target_rir}. "

      volumes = mesocycle.volume_summary
      if volumes.any?
        prompt += "\nVolume targets this week:\n"
        volumes.each do |v|
          prompt += "- #{v[:muscle_group]}: #{v[:week_volume]} sets (MEV: #{v[:mev]}, MRV: #{v[:mrv]})\n"
        end
      end
    end

    # Add available exercises for this location
    available = Exercise.for_location(location).includes(:muscle_group).group_by { |e| e.muscle_group.name }
    prompt += "\nAvailable exercises at #{location}:\n"
    available.each do |mg_name, exercises|
      prompt += "#{mg_name}: #{exercises.map(&:name).join(', ')}\n"
    end

    # Add recent performance data
    recent_workouts = user.workouts.strength_workouts.completed.recent.limit(3).includes(workout_exercises: [ :exercise, :exercise_sets ])
    if recent_workouts.any?
      prompt += "\nRecent workout history:\n"
      recent_workouts.each do |w|
        prompt += "#{w.date} (#{w.location}):\n"
        w.workout_exercises.each do |we|
          sets_info = we.exercise_sets.completed.map { |s| "#{s.weight}lbs x #{s.reps} @ RIR #{s.rir}" }.join(", ")
          prompt += "  - #{we.exercise.name}: #{sets_info}\n" if sets_info.present?
        end
      end
    end

    prompt += <<~JSON_FORMAT

      Return a JSON array of exercises for this workout. Each exercise should have:
      {
        "exercises": [
          {
            "name": "Exact exercise name from the available list",
            "sets": 3,
            "reps": "8-12",
            "rir": 2,
            "rest_seconds": 120,
            "notes": "Brief coaching cue or weight suggestion"
          }
        ]
      }

      rest_seconds guidelines: compound movements 90-180s, isolation movements 60-90s.

      Only use exercise names from the available list above. Return ONLY valid JSON, no other text.
    JSON_FORMAT

    prompt
  end

  def swap_prompt(workout_exercise)
    <<~PROMPT
      Replace "#{workout_exercise.exercise.name}" with a different exercise for the same muscle group (#{workout_exercise.exercise.muscle_group.name}).

      Available #{workout.location} exercises for #{workout_exercise.exercise.muscle_group.name}:
      #{Exercise.for_location(workout.location).for_muscle_group(workout_exercise.exercise.muscle_group).where.not(id: workout_exercise.exercise_id).pluck(:name).join(', ')}

      Current exercises already in this workout:
      #{workout.workout_exercises.where.not(id: workout_exercise.id).includes(:exercise).map { |we| we.exercise.name }.join(', ')}

      Return JSON:
      {
        "name": "Exact exercise name from the list",
        "sets": #{workout_exercise.target_sets},
        "reps": "#{workout_exercise.target_reps}",
        "rir": #{workout_exercise.target_rir || 2},
        "notes": "Brief coaching cue"
      }

      Return ONLY valid JSON, no other text.
    PROMPT
  end

  def parse_and_create_exercises(content)
    json = extract_json(content)
    data = JSON.parse(json)
    exercises_data = data.is_a?(Hash) ? data["exercises"] : data

    exercises_data.each_with_index do |ex_data, index|
      exercise = Exercise.find_by(name: ex_data["name"])
      next unless exercise

      workout.workout_exercises.create!(
        exercise: exercise,
        position: index + 1,
        target_sets: ex_data["sets"] || 3,
        target_reps: ex_data["reps"] || "8-12",
        target_rir: ex_data["rir"],
        rest_seconds: ex_data["rest_seconds"],
        notes: ex_data["notes"]
      )
    end

    workout.update!(status: :planned) if workout.workout_exercises.any?
  end

  def parse_swap_response(content, workout_exercise)
    json = extract_json(content)
    data = JSON.parse(json)
    new_exercise = Exercise.find_by(name: data["name"])
    return nil unless new_exercise

    workout_exercise.update!(
      exercise: new_exercise,
      target_sets: data["sets"] || workout_exercise.target_sets,
      target_reps: data["reps"] || workout_exercise.target_reps,
      target_rir: data["rir"] || workout_exercise.target_rir,
      notes: data["notes"]
    )

    new_exercise
  end

  def extract_json(content)
    # Try to extract JSON from markdown code blocks or raw response
    if content.include?("```")
      content.match(/```(?:json)?\s*\n?(.*?)\n?```/m)&.captures&.first || content
    else
      content.strip
    end
  end
end
