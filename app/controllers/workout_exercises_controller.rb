class WorkoutExercisesController < ApplicationController
  before_action :set_workout
  before_action :set_workout_exercise, only: [ :update, :destroy, :swap ]

  def update
    if @workout_exercise.update(workout_exercise_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to @workout }
      end
    else
      redirect_to @workout, alert: "Failed to update exercise."
    end
  end

  def destroy
    @workout_exercise.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@workout_exercise) }
      format.html { redirect_to @workout, notice: "Exercise removed." }
    end
  end

  def swap
    generator = Workout::Generator.new(
      user: Current.user,
      workout: @workout
    )

    new_exercise = generator.swap_exercise(@workout_exercise)

    if new_exercise
      respond_to do |format|
        format.turbo_stream {
          render turbo_stream: turbo_stream.replace(@workout_exercise,
            partial: "workout_exercises/workout_exercise",
            locals: { workout_exercise: @workout_exercise.reload })
        }
        format.html { redirect_to @workout, notice: "Exercise swapped!" }
      end
    else
      redirect_to @workout, alert: "Failed to swap exercise."
    end
  end

  private

  def set_workout
    @workout = Current.user.workouts.find(params[:workout_id])
  end

  def set_workout_exercise
    @workout_exercise = @workout.workout_exercises.find(params[:id])
  end

  def workout_exercise_params
    params.expect(workout_exercise: [ :notes ])
  end
end
