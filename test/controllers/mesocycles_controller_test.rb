require "test_helper"

class MesocyclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "index shows mesocycles" do
    get mesocycles_url
    assert_response :success
  end

  test "show displays mesocycle" do
    get mesocycle_url(mesocycles(:active))
    assert_response :success
  end

  test "new shows form" do
    get new_mesocycle_url
    assert_response :success
  end

  test "create starts a new mesocycle" do
    assert_difference("Mesocycle.count") do
      post mesocycles_url, params: { mesocycle: {
        split_type: "upper_lower",
        duration_weeks: 4
      } }
    end
    assert_redirected_to mesocycle_url(Mesocycle.last)
  end

  test "start_deload sets deloading" do
    post start_deload_mesocycle_url(mesocycles(:active))
    assert_redirected_to mesocycle_url(mesocycles(:active))
    assert mesocycles(:active).reload.deloading?
  end

  test "complete finishes mesocycle" do
    post complete_mesocycle_url(mesocycles(:active))
    assert_redirected_to mesocycles_url
    assert mesocycles(:active).reload.completed?
  end
end
