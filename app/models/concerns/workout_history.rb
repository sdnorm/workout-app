module WorkoutHistory
  extend ActiveSupport::Concern

  included do
    scope :for_muscle_groups, ->(muscle_group_names) {
      joins(workout_exercises: { exercise: :muscle_group })
        .where(muscle_groups: { name: muscle_group_names })
        .distinct
    }
  end

  class_methods do
    def recent_for_muscle_group(user, muscle_group_name, limit: 3)
      user.workouts
        .strength_workouts
        .completed
        .for_muscle_groups([ muscle_group_name ])
        .recent
        .limit(limit)
        .includes(workout_exercises: [ :exercise, :exercise_sets ])
    end

    def last_performance(user, exercise)
      user.workouts
        .strength_workouts
        .completed
        .joins(:workout_exercises)
        .where(workout_exercises: { exercise_id: exercise.id })
        .order(date: :desc)
        .first
        &.workout_exercises
        &.find_by(exercise: exercise)
    end

    def weekly_volume_completed(user, mesocycle, muscle_group, week)
      user.workouts
        .where(mesocycle: mesocycle, week_number: week)
        .completed
        .joins(workout_exercises: { exercise: :muscle_group })
        .where(muscle_groups: { id: muscle_group.id })
        .sum("workout_exercises.target_sets")
    end
  end

  def performance_summary
    workout_exercises.includes(:exercise, :exercise_sets).map do |we|
      sets_data = we.exercise_sets.completed.map do |s|
        { weight: s.weight, reps: s.reps, rir: s.rir }
      end

      {
        exercise: we.exercise.name,
        muscle_group: we.exercise.muscle_group.name,
        sets: sets_data
      }
    end
  end
end
