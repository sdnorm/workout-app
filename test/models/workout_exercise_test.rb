require "test_helper"

class WorkoutExerciseTest < ActiveSupport::TestCase
  test "validates position and target_sets" do
    we = WorkoutExercise.new(workout: workouts(:planned_gym), exercise: exercises(:bench_press))
    assert_not we.valid?
    assert_includes we.errors[:position], "can't be blank"
    assert_includes we.errors[:target_sets], "can't be blank"
  end

  test "completed_sets returns only completed sets" do
    we = workout_exercises(:bench_in_progress)
    assert_equal 2, we.completed_sets.count
  end

  test "next_set_number returns next number" do
    we = workout_exercises(:bench_in_progress)
    assert_equal 3, we.next_set_number  # has sets 1 and 2
  end

  test "all_sets_completed? when all target sets done" do
    we = workout_exercises(:bench_in_progress)
    assert_not we.all_sets_completed?  # 2 of 3 done

    # Add a third set
    we.exercise_sets.create!(set_number: 3, reps: 8, weight: 135, rir: 1, completed: true)
    assert we.all_sets_completed?
  end
end
