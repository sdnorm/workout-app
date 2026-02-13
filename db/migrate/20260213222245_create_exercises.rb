class CreateExercises < ActiveRecord::Migration[8.1]
  def change
    create_table :exercises do |t|
      t.string :name
      t.references :muscle_group, null: false, foreign_key: true
      t.string :equipment
      t.integer :movement_type
      t.integer :available_at

      t.timestamps
    end
  end
end
