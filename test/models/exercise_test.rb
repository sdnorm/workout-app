require "test_helper"

class ExerciseTest < ActiveSupport::TestCase
  test "validates name and equipment presence" do
    exercise = Exercise.new(muscle_group: muscle_groups(:chest))
    assert_not exercise.valid?
    assert_includes exercise.errors[:name], "can't be blank"
    assert_includes exercise.errors[:equipment], "can't be blank"
  end

  test "for_location scope returns gym and both exercises for gym" do
    gym_exercises = Exercise.for_location(:gym)
    assert_includes gym_exercises, exercises(:bench_press)     # gym only
    assert_includes gym_exercises, exercises(:dumbbell_bench)  # both
  end

  test "for_location scope returns home and both exercises for home" do
    home_exercises = Exercise.for_location(:home)
    assert home_exercises.include?(exercises(:dumbbell_bench))  # both
    assert home_exercises.include?(exercises(:pull_ups))        # both
    assert_not home_exercises.include?(exercises(:bench_press)) # gym only
  end

  test "compound and isolation enums" do
    assert exercises(:bench_press).compound?
    assert exercises(:dumbbell_flyes).isolation?
  end
end
