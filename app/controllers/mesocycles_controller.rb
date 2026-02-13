class MesocyclesController < ApplicationController
  before_action :set_mesocycle, only: [ :show, :edit, :update, :destroy, :start_deload, :complete ]

  def index
    @mesocycles = Current.user.mesocycles.order(created_at: :desc)
    @active_mesocycle = Current.user.active_mesocycle
  end

  def show
    @volumes = @mesocycle.mesocycle_volumes.includes(:muscle_group).order("muscle_groups.name")
  end

  def new
    @mesocycle = Current.user.mesocycles.new(duration_weeks: 4, split_type: "push_pull_legs")
  end

  def create
    @mesocycle = Current.user.mesocycles.new(mesocycle_params)

    if @mesocycle.save
      @mesocycle.initialize_volumes!
      redirect_to @mesocycle, notice: "Mesocycle started!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @mesocycle.update(mesocycle_params)
      redirect_to @mesocycle, notice: "Mesocycle updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @mesocycle.destroy
    redirect_to mesocycles_path, notice: "Mesocycle deleted."
  end

  def start_deload
    @mesocycle.start_deload!
    redirect_to @mesocycle, notice: "Deload week started!"
  end

  def complete
    @mesocycle.update!(status: :completed)
    redirect_to mesocycles_path, notice: "Mesocycle completed!"
  end

  private

  def set_mesocycle
    @mesocycle = Current.user.mesocycles.find(params[:id])
  end

  def mesocycle_params
    params.expect(mesocycle: [ :duration_weeks, :split_type, :notes ])
  end
end
