class AddUniqueIndexToProjectPlansUser < ActiveRecord::Migration[8.1]
  def change
    add_index :project_plans, :user, unique: true
  end
end
