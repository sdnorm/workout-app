require "test_helper"

class MesocycleTest < ActiveSupport::TestCase
  test "validates required fields" do
    meso = Mesocycle.new(user: users(:one))
    assert_not meso.valid?
    assert_includes meso.errors[:split_type], "can't be blank"
  end

  test "sets defaults on create" do
    meso = Mesocycle.create!(user: users(:one), split_type: "push_pull_legs", duration_weeks: 4)
    assert_equal 1, meso.current_week
    assert meso.active?
    assert_equal Date.current, meso.start_date
    assert_equal Date.current + 4.weeks, meso.end_date
  end

  test "target_rir returns correct RIR for week" do
    meso = mesocycles(:active)
    assert_equal 3, meso.target_rir  # week 1

    meso_w3 = mesocycles(:week_three)
    assert_equal 1, meso_w3.target_rir  # week 3
  end

  test "advance_week increments week" do
    meso = mesocycles(:active)
    assert_equal 1, meso.current_week
    meso.advance_week!
    assert_equal 2, meso.reload.current_week
  end

  test "advance_week completes at end" do
    meso = mesocycles(:week_three)
    meso.update!(current_week: 4)
    meso.advance_week!
    assert meso.reload.completed?
  end

  test "start_deload sets deloading status" do
    meso = mesocycles(:active)
    meso.start_deload!
    assert meso.reload.deloading?
  end

  test "initialize_volumes creates volumes for all muscle groups" do
    meso = Mesocycle.create!(user: users(:one), split_type: "full_body", duration_weeks: 4)
    meso.initialize_volumes!
    assert_equal MuscleGroup.count, meso.mesocycle_volumes.count
  end

  test "muscle_groups_for_session returns correct groups for PPL push" do
    meso = mesocycles(:active)
    groups = meso.muscle_groups_for_session("push")
    assert_includes groups, "Chest"
    assert_includes groups, "Triceps"
    assert_not_includes groups, "Back"
  end

  test "muscle_groups_for_session returns correct groups for PPL pull" do
    meso = mesocycles(:active)
    groups = meso.muscle_groups_for_session("pull")
    assert_includes groups, "Back"
    assert_includes groups, "Biceps"
    assert_not_includes groups, "Chest"
  end
end
