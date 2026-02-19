class CreateTrainingMethodologies < ActiveRecord::Migration[8.1]
  def change
    create_table :training_methodologies do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name, null: false
      t.text :description
      t.text :content, null: false
      t.boolean :active, default: false, null: false
      t.boolean :public, default: false, null: false

      t.timestamps
    end

    add_index :training_methodologies, [ :user_id, :active ]
  end
end
