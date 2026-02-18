require "test_helper"

class PreferencesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "show displays preferences" do
    get preferences_url
    assert_response :success
    assert_select "h1", "Workout Preferences"
  end

  test "edit shows form" do
    get edit_preferences_url
    assert_response :success
    assert_select "form"
  end

  test "update saves preferences" do
    patch preferences_url, params: {
      user_preference: {
        training_goal: "strength",
        home_equipment: [ "kettlebell", "pull_up_bar", "" ],
        workout_style: [ "prefer_supersets", "" ],
        equipment_notes: "Light kettlebell only",
        injuries_notes: "Bad left knee"
      }
    }
    assert_redirected_to preferences_url

    pref = users(:one).preference.reload
    assert_equal "strength", pref.training_goal
    assert_equal %w[kettlebell pull_up_bar], pref.home_equipment
    assert_equal %w[prefer_supersets], pref.workout_style
    assert_equal "Light kettlebell only", pref.equipment_notes
    assert_equal "Bad left knee", pref.injuries_notes
  end

  test "update strips normal priorities" do
    patch preferences_url, params: {
      user_preference: {
        training_goal: "hypertrophy",
        home_equipment: [],
        workout_style: [],
        muscle_group_priorities: { "Chest" => "priority", "Back" => "normal", "Quads" => "maintenance" }
      }
    }
    assert_redirected_to preferences_url

    pref = users(:one).preference.reload
    assert_equal "priority", pref.muscle_group_priorities["Chest"]
    assert_nil pref.muscle_group_priorities["Back"]
    assert_equal "maintenance", pref.muscle_group_priorities["Quads"]
  end

  test "creates preference on first save" do
    users(:one).preference.destroy
    assert_nil users(:one).reload.preference

    patch preferences_url, params: {
      user_preference: {
        training_goal: "recomp",
        home_equipment: [ "barbell" ],
        workout_style: []
      }
    }
    assert_redirected_to preferences_url
    assert_equal "recomp", users(:one).reload.preference.training_goal
  end

  test "requires authentication" do
    delete session_url
    get preferences_url
    assert_redirected_to new_session_url
  end
end
