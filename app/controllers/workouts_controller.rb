class WorkoutsController < ApplicationController
  before_action :set_workout, only: [ :show, :edit, :update, :destroy, :generate, :regenerate, :complete ]

  def index
    @current_workout = Current.user.workouts.where(status: [ :planned, :in_progress ]).order(created_at: :desc).first
    @recent_workouts = Current.user.workouts.completed.recent.limit(10)
    @active_mesocycle = Current.user.active_mesocycle
  end

  def show
    @workout_exercises = @workout.workout_exercises.includes(:exercise, :exercise_sets)
  end

  def new
    @workout = Current.user.workouts.new(date: Date.current)
    @active_mesocycle = Current.user.active_mesocycle
  end

  def create
    @workout = Current.user.workouts.new(workout_params)
    @workout.date ||= Date.current
    @workout.status = :planned

    if @active_mesocycle = Current.user.active_mesocycle
      @workout.mesocycle = @active_mesocycle
      @workout.week_number = @active_mesocycle.current_week
    end

    if @workout.save
      redirect_to generate_workout_path(@workout)
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
    generator = Workout::Generator.new(
      user: Current.user,
      workout: @workout
    )

    if generator.generate
      redirect_to @workout, notice: "Workout generated!"
    else
      redirect_to @workout, alert: "Failed to generate workout. #{generator.errors.full_messages.join(', ')}"
    end
  end

  def regenerate
    @workout.workout_exercises.destroy_all

    generator = Workout::Generator.new(
      user: Current.user,
      workout: @workout
    )

    if generator.generate
      redirect_to @workout, notice: "Workout regenerated!"
    else
      redirect_to @workout, alert: "Failed to regenerate workout."
    end
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
    params.expect(workout: [ :workout_type, :location, :date, :notes ])
  end
end
