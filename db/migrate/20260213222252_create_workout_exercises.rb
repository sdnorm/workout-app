class CreateWorkoutExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :workout_exercises do |t|
      t.references :workout, null: false, foreign_key: true
      t.references :exercise, null: false, foreign_key: true
      t.integer :position
      t.integer :target_sets
      t.string :target_reps
      t.integer :target_rir
      t.text :notes

      t.timestamps
    end
  end
end
