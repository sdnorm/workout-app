class MobilityRoutine::Generator
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :user
  attribute :mobility_routine

  validates :user, :mobility_routine, presence: true

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

  private

  def create_chat
    chat = user.chats.create!(model: user.default_provider_model)
    chat.with_instructions(system_prompt)
    chat
  end

  def system_prompt
    mobility_guide = File.read(Rails.root.join("guides", "mobility_methodology.md"))
    equipment_guide = File.read(Rails.root.join("guides", "equipment_profiles.md"))

    <<~PROMPT
      You are an expert mobility and flexibility coach with deep knowledge of stretching science, yoga, and myofascial release.

      #{mobility_guide}

      #{equipment_guide}

      IMPORTANT RULES:
      - Always return valid JSON and nothing else
      - Select exercises appropriate for the specified routine type and focus area
      - Order exercises logically (general to specific, large muscles to small)
      - Include clear coaching cues in the notes for each exercise
      - Specify bilateral/unilateral correctly for each exercise
      - Match total routine duration to the target
    PROMPT
  end

  def user_prompt
    routine = mobility_routine
    prompt = "Generate a #{routine.routine_type&.humanize&.downcase || 'mixed'} mobility routine"
    prompt += " focusing on #{routine.focus_area&.humanize&.downcase || 'full body'}."
    prompt += " Target duration: #{routine.duration_minutes || 15} minutes."

    # Add recent workout context for complementary mobility suggestions
    recent_workouts = user.workouts.completed.recent.limit(3).includes(workout_exercises: :exercise)
    if recent_workouts.any?
      prompt += "\n\nRecent training (suggest complementary mobility):\n"
      recent_workouts.each do |w|
        muscles = w.workout_exercises.map { |we| we.exercise.muscle_group&.name }.compact.uniq
        prompt += "- #{w.date}: #{muscles.join(', ')}\n" if muscles.any?
      end
    end

    prompt += <<~JSON_FORMAT

      Return a JSON object with exercises for this routine:
      {
        "exercises": [
          {
            "name": "Exercise name",
            "duration_seconds": 60,
            "sets": 2,
            "reps": null,
            "hold_seconds": 30,
            "side": "bilateral",
            "notes": "Coaching cue for proper form"
          }
        ]
      }

      Field guidelines:
      - duration_seconds: total time for the exercise (including all sets/sides)
      - sets: number of sets (null for single-set holds)
      - reps: number of reps for dynamic movements (null for static holds)
      - hold_seconds: per-rep hold time in seconds (null for dynamic-only movements)
      - side: "bilateral", "left", or "right" — use "left" for unilateral exercises (they'll be done both sides)
      - notes: brief coaching cue for form

      Return ONLY valid JSON, no other text.
    JSON_FORMAT

    prompt
  end

  def parse_and_create_exercises(content)
    json = extract_json(content)
    data = JSON.parse(json)
    exercises_data = data.is_a?(Hash) ? data["exercises"] : data

    exercises_data.each_with_index do |ex_data, index|
      mobility_routine.mobility_exercises.create!(
        name: ex_data["name"],
        position: index + 1,
        duration_seconds: ex_data["duration_seconds"],
        sets: ex_data["sets"],
        reps: ex_data["reps"],
        hold_seconds: ex_data["hold_seconds"],
        side: ex_data["side"] || "bilateral",
        notes: ex_data["notes"]
      )
    end
  end

  def extract_json(content)
    if content.include?("```")
      content.match(/```(?:json)?\s*\n?(.*?)\n?```/m)&.captures&.first || content
    else
      content.strip
    end
  end
end
