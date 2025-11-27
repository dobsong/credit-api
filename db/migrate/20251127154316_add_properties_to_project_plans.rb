class AddPropertiesToProjectPlans < ActiveRecord::Migration[8.1]
  def change
    add_column :project_plans, :user, :string, null: false
    add_column :project_plans, :previous_engagement, :boolean, null: false, default: false
    add_column :project_plans, :has_started, :boolean, null: false, default: false
    add_column :project_plans, :vision, :text
    add_column :project_plans, :laymans_summary, :text
    add_column :project_plans, :stakeholder_analysis, :text
    add_column :project_plans, :approach, :text
    add_column :project_plans, :data, :text
    add_column :project_plans, :ethics, :text
    add_column :project_plans, :platform, :text
    add_column :project_plans, :support_materials, :text
    add_column :project_plans, :costings, :text
  end
end
