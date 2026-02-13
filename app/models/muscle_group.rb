class MuscleGroup < ApplicationRecord
  has_many :exercises, dependent: :destroy
  has_many :mesocycle_volumes, dependent: :destroy
  has_many :exercise_secondary_muscles, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validates :default_mev, :default_mrv, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
