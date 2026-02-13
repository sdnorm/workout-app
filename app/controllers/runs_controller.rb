class RunsController < ApplicationController
  before_action :set_run, only: [ :show, :edit, :update, :destroy ]

  def index
    @runs = Current.user.runs.recent
    @run = Current.user.runs.new(date: Date.current)
  end

  def show
  end

  def new
    @run = Current.user.runs.new(date: Date.current)
  end

  def create
    @run = Current.user.runs.new(run_params)

    if @run.save
      redirect_to runs_path, notice: "Run logged!"
    else
      @runs = Current.user.runs.recent
      render :index, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @run.update(run_params)
      redirect_to runs_path, notice: "Run updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @run.destroy
    redirect_to runs_path, notice: "Run deleted."
  end

  private

  def set_run
    @run = Current.user.runs.find(params[:id])
  end

  def run_params
    params.expect(run: [ :date, :distance, :duration_minutes, :pace, :run_type, :notes ])
  end
end
