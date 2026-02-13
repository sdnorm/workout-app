class ExerciseSetsController < ApplicationController
  before_action :set_workout_and_exercise
  before_action :set_exercise_set, only: [ :update, :destroy ]

  def create
    @exercise_set = @workout_exercise.exercise_sets.new(exercise_set_params)
    @exercise_set.set_number = @workout_exercise.next_set_number

    @workout.update(status: :in_progress) if @workout.planned?

    if @exercise_set.save
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to workout_path(@workout) }
      end
    else
      redirect_to workout_path(@workout), alert: "Failed to log set."
    end
  end

  def update
    if @exercise_set.update(exercise_set_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to workout_path(@workout) }
      end
    else
      redirect_to workout_path(@workout), alert: "Failed to update set."
    end
  end

  def destroy
    @exercise_set.destroy
    respond_to do |format|
      format.turbo_stream { render turbo_stream: turbo_stream.remove(@exercise_set) }
      format.html { redirect_to workout_path(@workout), notice: "Set removed." }
    end
  end

  private

  def set_workout_and_exercise
    @workout = Current.user.workouts.find(params[:workout_id])
    @workout_exercise = @workout.workout_exercises.find(params[:workout_exercise_id])
  end

  def set_exercise_set
    @exercise_set = @workout_exercise.exercise_sets.find(params[:id])
  end

  def exercise_set_params
    params.expect(exercise_set: [ :reps, :weight, :rir, :completed, :notes ])
  end
end
