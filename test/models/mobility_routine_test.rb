require "test_helper"

class MobilityRoutineTest < ActiveSupport::TestCase
  test "validates date presence" do
    routine = MobilityRoutine.new(user: users(:one))
    assert_not routine.valid?
    assert_includes routine.errors[:date], "can't be blank"
  end

  test "validates duration is positive integer" do
    routine = MobilityRoutine.new(user: users(:one), date: Date.current, duration_minutes: -5)
    assert_not routine.valid?

    routine.duration_minutes = 0
    assert_not routine.valid?

    routine.duration_minutes = 15
    assert routine.valid?
  end

  test "allows nil duration" do
    routine = MobilityRoutine.new(user: users(:one), date: Date.current)
    assert routine.valid?
  end

  test "validates routine_type inclusion" do
    routine = MobilityRoutine.new(user: users(:one), date: Date.current, routine_type: "invalid")
    assert_not routine.valid?
    assert_includes routine.errors[:routine_type], "is not included in the list"
  end

  test "allows nil routine_type" do
    routine = MobilityRoutine.new(user: users(:one), date: Date.current)
    assert routine.valid?
  end

  test "validates focus_area inclusion" do
    routine = MobilityRoutine.new(user: users(:one), date: Date.current, focus_area: "invalid")
    assert_not routine.valid?
    assert_includes routine.errors[:focus_area], "is not included in the list"
  end

  test "allows nil focus_area" do
    routine = MobilityRoutine.new(user: users(:one), date: Date.current)
    assert routine.valid?
  end

  test "recent scope orders by date desc" do
    routines = MobilityRoutine.recent
    dates = routines.map(&:date)
    assert_equal dates, dates.sort.reverse
  end

  test "total_duration_display shows duration_minutes" do
    routine = mobility_routines(:logged_static)
    assert_equal "15 min", routine.total_duration_display
  end

  test "total_duration_display calculates from exercises when no duration" do
    routine = mobility_routines(:logged_static)
    routine.duration_minutes = nil
    assert_match(/\d+ min/, routine.total_duration_display)
  end

  test "logged_routines scope excludes generating" do
    routines = MobilityRoutine.logged_routines
    assert routines.all?(&:logged?)
  end
end
