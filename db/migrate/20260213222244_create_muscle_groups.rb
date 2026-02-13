class CreateMuscleGroups < ActiveRecord::Migration[8.1]
  def change
    create_table :muscle_groups do |t|
      t.string :name
      t.integer :default_mev
      t.integer :default_mrv

      t.timestamps
    end
  end
end
