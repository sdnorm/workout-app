require "test_helper"

class UserPreferenceTest < ActiveSupport::TestCase
  setup do
    @preference = user_preferences(:one)
  end

  test "belongs to user" do
    assert_equal users(:one), @preference.user
  end

  test "training goal enum" do
    assert @preference.hypertrophy?
    @preference.training_goal = :strength
    assert @preference.strength?
  end

  test "defaults for new record" do
    pref = UserPreference.new
    assert_equal [], pref.home_equipment
    assert_equal({}, pref.muscle_group_priorities)
    assert_equal [], pref.workout_style
    assert_equal "hypertrophy", pref.training_goal
  end

  test "priority_for returns stored priority" do
    assert_equal "priority", @preference.priority_for("Chest")
  end

  test "priority_for returns normal for unstored muscle groups" do
    assert_equal "normal", @preference.priority_for("Quads")
  end

  test "equipment_display_names maps keys to labels" do
    names = @preference.equipment_display_names
    assert_includes names, "Adjustable Dumbbells"
    assert_includes names, "Adjustable Bench"
    assert_includes names, "Pull-up Bar"
  end

  test "style_display_names maps keys to labels" do
    names = @preference.style_display_names
    assert_includes names, "Prefer Compound Movements"
    assert_includes names, "Prefer Free Weights"
  end

  test "validates equipment keys" do
    @preference.home_equipment = [ "invalid_key" ]
    assert_not @preference.valid?
    assert @preference.errors[:home_equipment].any?
  end

  test "validates style keys" do
    @preference.workout_style = [ "bad_style" ]
    assert_not @preference.valid?
    assert @preference.errors[:workout_style].any?
  end

  test "validates priority values" do
    @preference.muscle_group_priorities = { "Chest" => "invalid" }
    assert_not @preference.valid?
    assert @preference.errors[:muscle_group_priorities].any?
  end

  test "accepts valid data" do
    assert @preference.valid?
  end
end
