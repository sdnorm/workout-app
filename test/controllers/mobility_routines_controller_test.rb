require "test_helper"

class MobilityRoutinesControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as users(:one)
  end

  test "index shows mobility routines" do
    get mobility_routines_url
    assert_response :success
  end

  test "new shows form" do
    get new_mobility_routine_url
    assert_response :success
  end

  test "create logs a routine manually" do
    assert_difference("MobilityRoutine.count") do
      post mobility_routines_url, params: { mobility_routine: {
        date: Date.current,
        duration_minutes: 15,
        routine_type: "static_stretching",
        focus_area: "hips",
        notes: "Quick hip stretch"
      } }
    end
    assert_redirected_to mobility_routines_url
    assert MobilityRoutine.last.logged?
  end

  test "create with AI enqueues job and redirects to show" do
    assert_difference("MobilityRoutine.count") do
      post mobility_routines_url, params: {
        generate_ai: "1",
        mobility_routine: {
          date: Date.current,
          duration_minutes: 15,
          routine_type: "yoga",
          focus_area: "full_body"
        }
      }
    end
    routine = MobilityRoutine.last
    assert routine.generating?
    assert_redirected_to mobility_routine_url(routine)
  end

  test "show displays routine" do
    get mobility_routine_url(mobility_routines(:logged_static))
    assert_response :success
  end

  test "show displays generating state" do
    get mobility_routine_url(mobility_routines(:generating_routine))
    assert_response :success
  end

  test "edit shows form" do
    get edit_mobility_routine_url(mobility_routines(:logged_static))
    assert_response :success
  end

  test "update modifies routine" do
    patch mobility_routine_url(mobility_routines(:logged_static)), params: {
      mobility_routine: { duration_minutes: 20 }
    }
    assert_redirected_to mobility_routines_url
    assert_equal 20, mobility_routines(:logged_static).reload.duration_minutes
  end

  test "destroy deletes routine" do
    assert_difference("MobilityRoutine.count", -1) do
      delete mobility_routine_url(mobility_routines(:logged_static))
    end
    assert_redirected_to mobility_routines_url
  end

  test "generate triggers AI generation" do
    routine = mobility_routines(:logged_static)
    post generate_mobility_routine_url(routine)
    assert_redirected_to mobility_routine_url(routine)
    assert routine.reload.generating?
  end

  test "regenerate clears exercises and regenerates" do
    routine = mobility_routines(:logged_static)
    assert routine.mobility_exercises.any?

    post regenerate_mobility_routine_url(routine)
    assert_redirected_to mobility_routine_url(routine)
    assert routine.reload.generating?
    assert_equal 0, routine.mobility_exercises.count
  end

  test "complete marks all exercises completed" do
    routine = mobility_routines(:logged_static)
    post complete_mobility_routine_url(routine)
    assert_redirected_to mobility_routine_url(routine)
    assert routine.mobility_exercises.reload.all?(&:completed?)
  end

  test "requires authentication" do
    reset!
    get mobility_routines_url
    assert_redirected_to new_session_url
  end
end
