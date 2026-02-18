class CreateMobilityExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :mobility_exercises do |t|
      t.references :mobility_routine, null: false, foreign_key: true
      t.string :name, null: false
      t.integer :position, null: false
      t.integer :duration_seconds
      t.integer :sets
      t.integer :reps
      t.integer :hold_seconds
      t.string :side
      t.text :notes
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
