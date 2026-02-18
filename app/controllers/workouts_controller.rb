class WorkoutsController < ApplicationController
  before_action :set_workout, only: [ :show, :edit, :update, :destroy, :generate, :regenerate, :complete ]

  def index
    @current_workout = Current.user.workouts.where(status: [ :planned, :in_progress, :generating ]).order(created_at: :desc).first
    @recent_workouts = Current.user.workouts.completed.recent.limit(10)
    @active_mesocycle = Current.user.active_mesocycle
  end

  def show
    @workout_exercises = @workout.workout_exercises.includes(:exercise, :exercise_sets)
  end

  def new
    if active_workout = Current.user.workouts.where(status: [ :planned, :in_progress, :generating ]).first
      redirect_to workouts_path, alert: "You already have an active workout."
      return
    end
    @workout = Current.user.workouts.new(date: Date.current)
    @active_mesocycle = Current.user.active_mesocycle
  end

  def create
    if active_workout = Current.user.workouts.where(status: [ :planned, :in_progress, :generating ]).first
      redirect_to workouts_path, alert: "You already have an active workout."
      return
    end
    @workout = Current.user.workouts.new(workout_params)
    @workout.date ||= Date.current
    @workout.status = :planned

    if @active_mesocycle = Current.user.active_mesocycle
      @workout.mesocycle = @active_mesocycle
      @workout.week_number = @active_mesocycle.current_week
    end

    if @workout.save
      @workout.update!(status: :generating, generation_error: nil)
      GenerateWorkoutJob.perform_later(@workout)
      redirect_to @workout
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @workout.update(workout_params)
      redirect_to @workout
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @workout.destroy
    redirect_to workouts_path, notice: "Workout deleted."
  end

  def generate
    @workout.update!(status: :generating, generation_error: nil)
    GenerateWorkoutJob.perform_later(@workout)
    redirect_to @workout
  end

  def regenerate
    @workout.workout_exercises.destroy_all
    @workout.update!(status: :generating, generation_error: nil)
    GenerateWorkoutJob.perform_later(@workout)
    redirect_to @workout
  end

  def complete
    @workout.complete!
    redirect_to workouts_path, notice: "Workout completed!"
  end

  private

  def set_workout
    @workout = Current.user.workouts.find(params[:id])
  end

  def workout_params
    params.expect(workout: [ :workout_type, :location, :date, :notes, :target_duration_minutes ])
  end
end
