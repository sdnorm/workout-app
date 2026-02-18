class Workout < ApplicationRecord
  include WorkoutHistory

  belongs_to :user
  belongs_to :mesocycle, optional: true
  has_many :workout_exercises, -> { order(:position) }, dependent: :destroy
  has_many :exercises, through: :workout_exercises
  has_many :runs, dependent: :nullify

  enum :workout_type, { strength: 0, run: 1 }
  enum :location, { home: 0, gym: 1 }
  enum :status, { planned: 0, in_progress: 1, completed: 2, generating: 3, generation_failed: 4 }

  validates :date, presence: true
  validates :workout_type, presence: true
  validates :target_duration_minutes, numericality: { only_integer: true, greater_than: 0 }, allow_nil: true

  scope :recent, -> { order(date: :desc) }
  scope :strength_workouts, -> { where(workout_type: :strength) }

  def complete!
    update!(status: :completed)
  end

  def duration_display
    return nil unless completed? && created_at
    minutes = ((updated_at - created_at) / 60).round
    "#{minutes} min"
  end
end
