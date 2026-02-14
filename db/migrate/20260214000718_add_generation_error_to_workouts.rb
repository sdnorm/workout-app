class AddGenerationErrorToWorkouts < ActiveRecord::Migration[8.1]
  def change
    add_column :workouts, :generation_error, :text
  end
end
