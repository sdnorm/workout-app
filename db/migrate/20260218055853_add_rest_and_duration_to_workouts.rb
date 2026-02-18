class AddRestAndDurationToWorkouts < ActiveRecord::Migration[8.1]
  def change
    add_column :workouts, :target_duration_minutes, :integer, default: 45
    add_column :workout_exercises, :rest_seconds, :integer
  end
end
