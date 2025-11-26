require "test_helper"

class ProjectPlansControllerTest < ActionDispatch::IntegrationTest
  setup do
    @project_plan = project_plans(:one)
  end

  test "should get index" do
    get project_plans_url, as: :json
    assert_response :success
  end

  test "should create project_plan" do
    assert_difference("ProjectPlan.count") do
      post project_plans_url, params: { project_plan: { title: @project_plan.title } }, as: :json
    end

    assert_response :created
  end

  test "should show project_plan" do
    get project_plan_url(@project_plan), as: :json
    assert_response :success
  end

  test "should update project_plan" do
    patch project_plan_url(@project_plan), params: { project_plan: { title: @project_plan.title } }, as: :json
    assert_response :success
  end

  test "should destroy project_plan" do
    assert_difference("ProjectPlan.count", -1) do
      delete project_plan_url(@project_plan), as: :json
    end

    assert_response :no_content
  end
end
