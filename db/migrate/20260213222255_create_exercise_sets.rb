class CreateExerciseSets < ActiveRecord::Migration[8.1]
  def change
    create_table :exercise_sets do |t|
      t.references :workout_exercise, null: false, foreign_key: true
      t.integer :set_number
      t.integer :reps
      t.decimal :weight
      t.integer :rir
      t.boolean :completed, default: false
      t.text :notes

      t.timestamps
    end
  end
end
