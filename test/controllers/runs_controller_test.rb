require "test_helper"

class RunsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "index shows runs" do
    get runs_url
    assert_response :success
  end

  test "new shows form" do
    get new_run_url
    assert_response :success
  end

  test "create logs a run" do
    assert_difference("Run.count") do
      post runs_url, params: { run: {
        date: Date.current,
        distance: 3.0,
        duration_minutes: 25,
        run_type: "easy",
        notes: "Good run"
      } }
    end
    assert_redirected_to runs_url
  end

  test "update modifies run" do
    patch run_url(runs(:easy_run)), params: { run: { distance: 4.0 } }
    assert_redirected_to runs_url
    assert_equal 4.0, runs(:easy_run).reload.distance
  end

  test "destroy deletes run" do
    assert_difference("Run.count", -1) do
      delete run_url(runs(:easy_run))
    end
    assert_redirected_to runs_url
  end
end
