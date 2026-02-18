class PreferencesController < ApplicationController
  def show
    @preference = current_preference
  end

  def edit
    @preference = current_preference
    @muscle_groups = MuscleGroup.order(:name)
  end

  def update
    @preference = current_preference

    if @preference.update(preference_params)
      redirect_to preferences_path, notice: "Preferences saved."
    else
      @muscle_groups = MuscleGroup.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def current_preference
    Current.user.preference || Current.user.build_preference
  end

  def preference_params
    permitted = params.require(:user_preference).permit(
      :equipment_notes, :training_goal, :style_notes, :injuries_notes,
      home_equipment: [], workout_style: [],
      muscle_group_priorities: MuscleGroup.pluck(:name)
    )

    # Strip blank entries from checkbox arrays
    permitted[:home_equipment] = permitted[:home_equipment]&.reject(&:blank?) || []
    permitted[:workout_style] = permitted[:workout_style]&.reject(&:blank?) || []

    # Strip "normal" entries from priorities (only store non-default values)
    if permitted[:muscle_group_priorities]
      permitted[:muscle_group_priorities] = permitted[:muscle_group_priorities].to_h.reject { |_, v| v == "normal" || v.blank? }
    end

    permitted
  end
end
