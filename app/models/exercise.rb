class Exercise < ApplicationRecord
  belongs_to :muscle_group
  has_many :exercise_secondary_muscles, dependent: :destroy
  has_many :secondary_muscle_groups, through: :exercise_secondary_muscles, source: :muscle_group
  has_many :workout_exercises, dependent: :destroy

  enum :movement_type, { compound: 0, isolation: 1 }
  enum :available_at, { home: 0, gym: 1, both: 2 }

  validates :name, presence: true
  validates :equipment, presence: true

  scope :for_location, ->(location) {
    where(available_at: [ :both, location.to_sym ])
  }

  scope :for_muscle_group, ->(muscle_group) {
    where(muscle_group: muscle_group)
  }
end
