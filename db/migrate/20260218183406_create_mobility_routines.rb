class CreateMobilityRoutines < ActiveRecord::Migration[8.1]
  def change
    create_table :mobility_routines do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date, null: false
      t.integer :duration_minutes
      t.string :routine_type
      t.string :focus_area
      t.text :notes
      t.integer :status, default: 0
      t.text :generation_error

      t.timestamps
    end
  end
end
