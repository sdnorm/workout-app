class MobilityRoutine < ApplicationRecord
  belongs_to :user
  has_many :mobility_exercises, -> { order(:position) }, dependent: :destroy

  ROUTINE_TYPES = %w[static_stretching dynamic_stretching yoga foam_rolling mixed].freeze
  FOCUS_AREAS = %w[full_body hips shoulders spine lower_body upper_body ankles wrists].freeze

  enum :status, { logged: 0, generating: 1, generation_failed: 2 }

  validates :date, presence: true
  validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :routine_type, inclusion: { in: ROUTINE_TYPES }, allow_nil: true
  validates :focus_area, inclusion: { in: FOCUS_AREAS }, allow_nil: true

  scope :recent, -> { order(date: :desc) }
  scope :logged_routines, -> { where(status: :logged) }

  def total_duration_display
    if duration_minutes.present?
      "#{duration_minutes} min"
    elsif mobility_exercises.any?
      total_seconds = mobility_exercises.sum(:duration_seconds)
      "#{(total_seconds / 60.0).ceil} min" if total_seconds > 0
    end
  end
end
