class CreateWorkouts < ActiveRecord::Migration[8.1]
  def change
    create_table :workouts do |t|
      t.references :user, null: false, foreign_key: true
      t.references :mesocycle, null: true, foreign_key: true
      t.integer :workout_type
      t.integer :location
      t.date :date
      t.integer :status
      t.integer :week_number
      t.text :notes

      t.timestamps
    end
  end
end
