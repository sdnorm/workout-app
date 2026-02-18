require "test_helper"

class WorkoutsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "index shows workouts" do
    get workouts_url
    assert_response :success
  end

  test "new shows location picker" do
    users(:one).workouts.where(status: [ :planned, :in_progress, :generating ]).update_all(status: :completed)
    get new_workout_url
    assert_response :success
    assert_select "input[name='workout[location]']"
  end

  test "new redirects when active workout exists" do
    get new_workout_url
    assert_redirected_to workouts_url
  end

  test "create creates a workout" do
    users(:one).workouts.where(status: [ :planned, :in_progress, :generating ]).update_all(status: :completed)
    assert_difference("Workout.count") do
      post workouts_url, params: { workout: { workout_type: "strength", location: "gym" } }
    end
  end

  test "create redirects when active workout exists" do
    assert_no_difference("Workout.count") do
      post workouts_url, params: { workout: { workout_type: "strength", location: "gym" } }
    end
    assert_redirected_to workouts_url
  end

  test "show displays workout" do
    get workout_url(workouts(:in_progress_gym))
    assert_response :success
  end

  test "complete marks workout as completed" do
    post complete_workout_url(workouts(:in_progress_gym))
    assert_redirected_to workouts_url
    assert workouts(:in_progress_gym).reload.completed?
  end

  test "destroy deletes workout" do
    assert_difference("Workout.count", -1) do
      delete workout_url(workouts(:planned_gym))
    end
    assert_redirected_to workouts_url
  end

  test "generate enqueues job and redirects" do
    workout = workouts(:planned_gym)
    assert_enqueued_with(job: GenerateWorkoutJob, args: [workout]) do
      post generate_workout_url(workout)
    end
    assert_redirected_to workout_url(workout)
    assert workout.reload.generating?
  end

  test "regenerate clears exercises and enqueues job" do
    workout = workouts(:in_progress_gym)
    assert_enqueued_with(job: GenerateWorkoutJob, args: [workout]) do
      post regenerate_workout_url(workout)
    end
    assert_redirected_to workout_url(workout)
    assert workout.reload.generating?
  end

  test "show displays generating state" do
    workout = workouts(:planned_gym)
    workout.update!(status: :generating)
    get workout_url(workout)
    assert_response :success
    assert_select "[data-controller='poll']"
  end

  test "show displays generation_failed state" do
    workout = workouts(:planned_gym)
    workout.update!(status: :generation_failed, generation_error: "API error")
    get workout_url(workout)
    assert_response :success
    assert_select "p", text: /API error/
  end

  test "requires authentication" do
    sign_out
    get workouts_url
    assert_redirected_to new_session_url
  end
end
