require "test_helper"

class ExerciseSetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
    @workout = workouts(:in_progress_gym)
    @workout_exercise = workout_exercises(:bench_in_progress)
  end

  test "create logs a set" do
    assert_difference("ExerciseSet.count") do
      post workout_workout_exercise_exercise_sets_url(@workout, @workout_exercise), params: {
        exercise_set: { reps: 10, weight: 140, rir: 2, completed: true }
      }
    end
  end

  test "create transitions workout to in_progress" do
    planned = workouts(:planned_gym)
    we = planned.workout_exercises.create!(exercise: exercises(:bench_press), position: 1, target_sets: 3)

    post workout_workout_exercise_exercise_sets_url(planned, we), params: {
      exercise_set: { reps: 10, weight: 135, rir: 3, completed: true }
    }
    assert planned.reload.in_progress?
  end

  test "destroy removes a set" do
    set = exercise_sets(:bench_set_one)
    assert_difference("ExerciseSet.count", -1) do
      delete workout_workout_exercise_exercise_set_url(@workout, @workout_exercise, set)
    end
  end
end
