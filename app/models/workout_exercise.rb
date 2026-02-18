class WorkoutExercise < ApplicationRecord
  belongs_to :workout
  belongs_to :exercise
  has_many :exercise_sets, -> { order(:set_number) }, dependent: :destroy

  validates :position, presence: true
  validates :target_sets, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def suggested_rest_seconds
    rest_seconds || (exercise.compound? ? 90 : 60)
  end

  def completed_sets
    exercise_sets.where(completed: true)
  end

  def all_sets_completed?
    completed_sets.count >= target_sets
  end

  def next_set_number
    (exercise_sets.maximum(:set_number) || 0) + 1
  end
end
