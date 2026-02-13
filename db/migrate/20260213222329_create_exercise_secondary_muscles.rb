class CreateExerciseSecondaryMuscles < ActiveRecord::Migration[8.1]
  def change
    create_table :exercise_secondary_muscles do |t|
      t.references :exercise, null: false, foreign_key: true
      t.references :muscle_group, null: false, foreign_key: true

      t.timestamps
    end
  end
end
