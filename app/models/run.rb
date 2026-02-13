class Run < ApplicationRecord
  belongs_to :user
  belongs_to :workout, optional: true

  validates :date, presence: true
  validates :distance, numericality: { greater_than: 0 }, allow_nil: true
  validates :duration_minutes, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  scope :recent, -> { order(date: :desc) }

  def calculated_pace
    return nil unless distance.present? && distance > 0 && duration_minutes.present?
    pace_minutes = duration_minutes / distance
    minutes = pace_minutes.floor
    seconds = ((pace_minutes - minutes) * 60).round
    format("%d:%02d /mi", minutes, seconds)
  end

  def display_pace
    pace.presence || calculated_pace
  end
end
