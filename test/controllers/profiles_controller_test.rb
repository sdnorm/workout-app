require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "show displays profile" do
    get profile_url
    assert_response :success
  end

  test "edit shows form" do
    get edit_profile_url
    assert_response :success
  end

  test "update saves preferences" do
    patch profile_url, params: { user: { training_experience: "advanced", default_provider: "xai" } }
    assert_redirected_to profile_url
    user = users(:one).reload
    assert user.advanced?
    assert_equal "xai", user.default_provider
  end
end
