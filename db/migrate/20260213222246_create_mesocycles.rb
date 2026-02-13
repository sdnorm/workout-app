class CreateMesocycles < ActiveRecord::Migration[8.1]
  def change
    create_table :mesocycles do |t|
      t.references :user, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :duration_weeks
      t.integer :current_week
      t.integer :status
      t.string :split_type
      t.text :notes

      t.timestamps
    end
  end
end
