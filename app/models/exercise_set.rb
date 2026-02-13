class ExerciseSet < ApplicationRecord
  belongs_to :workout_exercise

  validates :set_number, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validates :reps, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true
  validates :weight, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :rir, numericality: { only_integer: true, in: 0..5 }, allow_nil: true

  scope :completed, -> { where(completed: true) }

  def volume
    (reps || 0) * (weight || 0)
  end
end
