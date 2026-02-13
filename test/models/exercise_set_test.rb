require "test_helper"

class ExerciseSetTest < ActiveSupport::TestCase
  test "validates set_number presence" do
    es = ExerciseSet.new(workout_exercise: workout_exercises(:bench_in_progress))
    assert_not es.valid?
    assert_includes es.errors[:set_number], "can't be blank"
  end

  test "validates reps is positive" do
    es = ExerciseSet.new(
      workout_exercise: workout_exercises(:bench_in_progress),
      set_number: 3, reps: 0
    )
    assert_not es.valid?
  end

  test "validates rir is 0-5" do
    es = ExerciseSet.new(
      workout_exercise: workout_exercises(:bench_in_progress),
      set_number: 3, rir: 6
    )
    assert_not es.valid?
  end

  test "volume calculation" do
    es = exercise_sets(:bench_set_one)
    assert_equal 1350.0, es.volume  # 10 reps * 135 lbs
  end

  test "completed scope" do
    completed = ExerciseSet.completed
    assert completed.all?(&:completed?)
  end
end
