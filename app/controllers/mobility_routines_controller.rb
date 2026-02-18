class MobilityRoutinesController < ApplicationController
  before_action :set_mobility_routine, only: [ :show, :edit, :update, :destroy, :generate, :regenerate, :complete ]

  def index
    @generating_routine = Current.user.mobility_routines.where(status: :generating).order(created_at: :desc).first
    @mobility_routines = Current.user.mobility_routines.logged_routines.recent
  end

  def show
    @mobility_exercises = @mobility_routine.mobility_exercises
  end

  def new
    @mobility_routine = Current.user.mobility_routines.new(date: Date.current)
  end

  def create
    @mobility_routine = Current.user.mobility_routines.new(mobility_routine_params)
    @mobility_routine.date ||= Date.current

    if params[:generate_ai].present?
      @mobility_routine.status = :generating
      if @mobility_routine.save
        GenerateMobilityRoutineJob.perform_later(@mobility_routine)
        redirect_to @mobility_routine
      else
        render :new, status: :unprocessable_entity
      end
    else
      @mobility_routine.status = :logged
      if @mobility_routine.save
        redirect_to mobility_routines_path, notice: "Mobility routine logged!"
      else
        render :new, status: :unprocessable_entity
      end
    end
  end

  def edit
  end

  def update
    if @mobility_routine.update(mobility_routine_params)
      redirect_to mobility_routines_path, notice: "Mobility routine updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mobility_routine.destroy
    redirect_to mobility_routines_path, notice: "Mobility routine deleted."
  end

  def generate
    @mobility_routine.update!(status: :generating, generation_error: nil)
    GenerateMobilityRoutineJob.perform_later(@mobility_routine)
    redirect_to @mobility_routine
  end

  def regenerate
    @mobility_routine.mobility_exercises.destroy_all
    @mobility_routine.update!(status: :generating, generation_error: nil)
    GenerateMobilityRoutineJob.perform_later(@mobility_routine)
    redirect_to @mobility_routine
  end

  def complete
    @mobility_routine.mobility_exercises.update_all(completed: true)
    redirect_to @mobility_routine, notice: "All exercises completed!"
  end

  private

  def set_mobility_routine
    @mobility_routine = Current.user.mobility_routines.find(params[:id])
  end

  def mobility_routine_params
    params.expect(mobility_routine: [ :date, :duration_minutes, :routine_type, :focus_area, :notes ])
  end
end
