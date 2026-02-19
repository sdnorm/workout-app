require "test_helper"

class TrainingMethodologiesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
    @methodology = training_methodologies(:rp_default)
    @inactive = training_methodologies(:custom_inactive)
  end

  test "index shows methodologies" do
    get training_methodologies_url
    assert_response :success
  end

  test "show displays methodology" do
    get training_methodology_url(@methodology)
    assert_response :success
  end

  test "new shows form" do
    get new_training_methodology_url
    assert_response :success
  end

  test "create saves a new methodology" do
    assert_difference("TrainingMethodology.count") do
      post training_methodologies_url, params: { training_methodology: {
        name: "New Program",
        content: "Some training content"
      } }
    end
    assert_redirected_to training_methodology_url(TrainingMethodology.last)
  end

  test "create with invalid params renders new" do
    assert_no_difference("TrainingMethodology.count") do
      post training_methodologies_url, params: { training_methodology: {
        name: "",
        content: ""
      } }
    end
    assert_response :unprocessable_entity
  end

  test "edit shows form" do
    get edit_training_methodology_url(@methodology)
    assert_response :success
  end

  test "update saves changes" do
    patch training_methodology_url(@methodology), params: { training_methodology: {
      name: "Updated Name"
    } }
    assert_redirected_to training_methodology_url(@methodology)
    assert_equal "Updated Name", @methodology.reload.name
  end

  test "update with invalid params renders edit" do
    patch training_methodology_url(@methodology), params: { training_methodology: {
      name: ""
    } }
    assert_response :unprocessable_entity
  end

  test "destroy deletes methodology" do
    assert_difference("TrainingMethodology.count", -1) do
      delete training_methodology_url(@inactive)
    end
    assert_redirected_to training_methodologies_url
  end

  test "destroying active methodology activates most recent remaining" do
    delete training_methodology_url(@methodology)
    assert @inactive.reload.active?
  end

  test "activate sets methodology as active" do
    post activate_training_methodology_url(@inactive)
    assert_redirected_to training_methodologies_url
    assert @inactive.reload.active?
    assert_not @methodology.reload.active?
  end

  test "requires authentication" do
    reset!
    get training_methodologies_url
    assert_redirected_to new_session_url
  end
end
