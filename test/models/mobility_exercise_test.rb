require "test_helper"

class MobilityExerciseTest < ActiveSupport::TestCase
  test "validates name presence" do
    exercise = MobilityExercise.new(mobility_routine: mobility_routines(:logged_static), position: 1)
    assert_not exercise.valid?
    assert_includes exercise.errors[:name], "can't be blank"
  end

  test "validates position presence" do
    exercise = MobilityExercise.new(mobility_routine: mobility_routines(:logged_static), name: "Test")
    assert_not exercise.valid?
    assert_includes exercise.errors[:position], "can't be blank"
  end

  test "prescription_display with sets and hold" do
    exercise = mobility_exercises(:pigeon_stretch)
    display = exercise.prescription_display
    assert_includes display, "2 sets"
    assert_includes display, "30s hold"
    assert_includes display, "each side"
  end

  test "prescription_display with sets and reps" do
    exercise = mobility_exercises(:hip_cars)
    display = exercise.prescription_display
    assert_includes display, "2 sets"
    assert_includes display, "5 reps"
    assert_includes display, "each side"
  end

  test "prescription_display with bilateral exercise" do
    exercise = MobilityExercise.new(
      mobility_routine: mobility_routines(:logged_static),
      name: "Cat-Cow",
      position: 1,
      sets: 2,
      reps: 10,
      side: "bilateral"
    )
    display = exercise.prescription_display
    assert_includes display, "2 sets"
    assert_includes display, "10 reps"
    assert_not_includes display, "each side"
  end

  test "duration_display formats seconds" do
    exercise = MobilityExercise.new(duration_seconds: 45)
    assert_equal "45s", exercise.duration_display

    exercise.duration_seconds = 90
    assert_equal "1:30", exercise.duration_display
  end

  test "duration_display returns nil when no duration" do
    exercise = MobilityExercise.new
    assert_nil exercise.duration_display
  end
end
