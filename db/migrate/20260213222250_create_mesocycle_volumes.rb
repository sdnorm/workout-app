class CreateMesocycleVolumes < ActiveRecord::Migration[8.1]
  def change
    create_table :mesocycle_volumes do |t|
      t.references :mesocycle, null: false, foreign_key: true
      t.references :muscle_group, null: false, foreign_key: true
      t.integer :starting_sets
      t.integer :current_sets
      t.integer :mev
      t.integer :mav
      t.integer :mrv

      t.timestamps
    end
  end
end
