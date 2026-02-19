class TrainingMethodologiesController < ApplicationController
  before_action :set_training_methodology, only: [ :show, :edit, :update, :destroy, :activate ]

  def index
    @training_methodologies = Current.user.training_methodologies.order(active: :desc, created_at: :desc)
  end

  def show
  end

  def new
    @training_methodology = Current.user.training_methodologies.new
  end

  def create
    @training_methodology = Current.user.training_methodologies.new(training_methodology_params)

    if @training_methodology.save
      @training_methodology.activate! if Current.user.training_methodologies.count == 1
      redirect_to @training_methodology, notice: "Training methodology created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @training_methodology.update(training_methodology_params)
      redirect_to @training_methodology, notice: "Training methodology updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    was_active = @training_methodology.active?
    @training_methodology.destroy

    if was_active
      most_recent = Current.user.training_methodologies.order(created_at: :desc).first
      most_recent&.activate!
    end

    redirect_to training_methodologies_path, notice: "Training methodology deleted."
  end

  def activate
    @training_methodology.activate!
    redirect_to training_methodologies_path, notice: "#{@training_methodology.name} is now active."
  end

  private

  def set_training_methodology
    @training_methodology = Current.user.training_methodologies.find(params[:id])
  end

  def training_methodology_params
    params.expect(training_methodology: [ :name, :description, :content ])
  end
end
