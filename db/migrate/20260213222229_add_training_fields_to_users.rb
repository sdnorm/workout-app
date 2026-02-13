class AddTrainingFieldsToUsers < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :training_experience, :integer, default: 1
    add_column :users, :default_provider, :string, default: "anthropic"
  end
end
