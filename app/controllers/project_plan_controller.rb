
class ProjectPlanController < ApplicationController
  before_action :set_project_plan, only: %i[ show update destroy ]

  # There is a single project plan per user, with the username as the key.

  # GET /project_plan
  def show
    render json: @project_plan
  end

  # POST /project_plan
  def create
    @project_plan = ProjectPlan.new(project_plan_params)

    if @project_plan.save
      render json: @project_plan, status: :created, location: @project_plan
    else
      render json: @project_plan.errors, status: :unprocessable_content
    end
  end

  # PATCH/PUT /project_plan
  def update
    if @project_plan.update(project_plan_params)
      render json: @project_plan
    else
      render json: @project_plan.errors, status: :unprocessable_content
    end
  end

  # DELETE /project_plan
  def destroy
    @project_plan.destroy!
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_project_plan
      @project_plan = ProjectPlan.find_by(user: current_user["preferred_username"])
    end

    # Only allow a list of trusted parameters through.
    def project_plan_params
      # Username is pulled from the token (See KeyCloakAuthenticatable)
      username = current_user["preferred_username"]
      params.require(:project_plan).permit(:title, :previous_engagement, :has_started, :vision, :laymans_summary, :stakeholder_analysis, :approach, :data, :ethics, :platform, :support_materials, :costings).merge(user: username)
    end
end
