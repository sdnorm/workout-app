class UserPreference < ApplicationRecord
  belongs_to :user

  enum :training_goal, { hypertrophy: 0, strength: 1, recomp: 2, cut: 3 }

  EQUIPMENT_OPTIONS = {
    "adjustable_dumbbells" => "Adjustable Dumbbells",
    "fixed_dumbbells" => "Fixed Dumbbells",
    "barbell" => "Barbell & Plates",
    "kettlebell" => "Kettlebell",
    "pull_up_bar" => "Pull-up Bar",
    "resistance_bands" => "Resistance Bands",
    "cable_machine" => "Cable Machine",
    "squat_rack" => "Squat Rack",
    "bench" => "Adjustable Bench",
    "leg_press" => "Leg Press",
    "leg_extension" => "Leg Extension/Curl",
    "smith_machine" => "Smith Machine",
    "pec_deck" => "Pec Deck",
    "lat_pulldown" => "Lat Pulldown",
    "ab_wheel" => "Ab Wheel"
  }.freeze

  STYLE_OPTIONS = {
    "prefer_supersets" => "Prefer Supersets",
    "prefer_compounds" => "Prefer Compound Movements",
    "prefer_isolation" => "Prefer Isolation Work",
    "prefer_machines" => "Prefer Machines",
    "prefer_free_weights" => "Prefer Free Weights",
    "prefer_high_volume" => "Prefer Higher Volume",
    "prefer_low_volume" => "Prefer Lower Volume",
    "prefer_variety" => "Prefer Exercise Variety"
  }.freeze

  PRIORITY_OPTIONS = %w[priority normal maintenance].freeze

  validates :home_equipment, :workout_style, allow_blank: true, length: {
    maximum: 50, message: "has too many items"
  }

  validate :validate_equipment_keys
  validate :validate_style_keys
  validate :validate_priority_values

  def home_equipment
    super || []
  end

  def muscle_group_priorities
    super || {}
  end

  def workout_style
    super || []
  end

  def priority_for(muscle_group_name)
    muscle_group_priorities.fetch(muscle_group_name, "normal")
  end

  def equipment_display_names
    home_equipment.filter_map { |key| EQUIPMENT_OPTIONS[key] }
  end

  def style_display_names
    workout_style.filter_map { |key| STYLE_OPTIONS[key] }
  end

  private

  def validate_equipment_keys
    return if home_equipment.blank?
    invalid = home_equipment - EQUIPMENT_OPTIONS.keys
    errors.add(:home_equipment, "contains invalid options: #{invalid.join(', ')}") if invalid.any?
  end

  def validate_style_keys
    return if workout_style.blank?
    invalid = workout_style - STYLE_OPTIONS.keys
    errors.add(:workout_style, "contains invalid options: #{invalid.join(', ')}") if invalid.any?
  end

  def validate_priority_values
    return if muscle_group_priorities.blank?
    invalid = muscle_group_priorities.values - PRIORITY_OPTIONS
    errors.add(:muscle_group_priorities, "contains invalid priority values") if invalid.any?
  end
end
