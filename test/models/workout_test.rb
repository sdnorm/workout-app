require "test_helper"

class WorkoutTest < ActiveSupport::TestCase
  test "validates date and workout_type" do
    workout = Workout.new(user: users(:one))
    assert_not workout.valid?
    assert_includes workout.errors[:date], "can't be blank"
  end

  test "status enum" do
    assert workouts(:planned_gym).planned?
    assert workouts(:in_progress_gym).in_progress?
    assert workouts(:completed_gym).completed?
  end

  test "complete! marks as completed" do
    workout = workouts(:in_progress_gym)
    workout.complete!
    assert workout.reload.completed?
  end

  test "recent scope orders by date desc" do
    workouts = Workout.recent
    dates = workouts.map(&:date)
    assert_equal dates, dates.sort.reverse
  end

  test "performance_summary returns exercise data" do
    workout = workouts(:completed_gym)
    summary = workout.performance_summary
    assert summary.is_a?(Array)
  end
end
