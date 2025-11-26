class CreateProjectPlans < ActiveRecord::Migration[8.1]
  def change
    create_table :project_plans do |t|
      t.string :title

      t.timestamps
    end
  end
end
