class CreateRuns < ActiveRecord::Migration[8.1]
  def change
    create_table :runs do |t|
      t.references :user, null: false, foreign_key: true
      t.references :workout, null: true, foreign_key: true
      t.date :date
      t.decimal :distance
      t.integer :duration_minutes
      t.string :pace
      t.string :run_type
      t.text :notes

      t.timestamps
    end
  end
end
