require "test_helper"

class RunTest < ActiveSupport::TestCase
  test "validates date presence" do
    run = Run.new(user: users(:one))
    assert_not run.valid?
    assert_includes run.errors[:date], "can't be blank"
  end

  test "validates distance is positive" do
    run = Run.new(user: users(:one), date: Date.current, distance: -1)
    assert_not run.valid?
  end

  test "calculated_pace computes correctly" do
    run = runs(:easy_run)
    pace = run.calculated_pace
    assert_match(%r{\d+:\d{2} /mi}, pace)
  end

  test "calculated_pace returns nil when data missing" do
    run = Run.new(user: users(:one), date: Date.current)
    assert_nil run.calculated_pace
  end

  test "display_pace uses manual pace when present" do
    run = runs(:easy_run)
    run.pace = "8:30 /mi"
    assert_equal "8:30 /mi", run.display_pace
  end

  test "display_pace falls back to calculated" do
    run = runs(:easy_run)
    assert_equal run.calculated_pace, run.display_pace
  end

  test "recent scope orders by date desc" do
    runs = Run.recent
    dates = runs.map(&:date)
    assert_equal dates, dates.sort.reverse
  end
end
