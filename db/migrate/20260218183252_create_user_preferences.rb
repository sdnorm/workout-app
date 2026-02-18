class CreateUserPreferences < ActiveRecord::Migration[8.1]
  def change
    create_table :user_preferences do |t|
      t.references :user, null: false, foreign_key: true, index: { unique: true }
      t.json :home_equipment, default: []
      t.text :equipment_notes
      t.integer :training_goal, default: 0
      t.json :muscle_group_priorities, default: {}
      t.json :workout_style, default: []
      t.text :style_notes
      t.text :injuries_notes
      t.timestamps
    end
  end
end
