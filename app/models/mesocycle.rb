class Mesocycle < ApplicationRecord
  include RpPeriodization

  belongs_to :user
  has_many :mesocycle_volumes, dependent: :destroy
  has_many :workouts, dependent: :nullify

  enum :status, { active: 0, completed: 1, deloading: 2 }

  validates :duration_weeks, presence: true, numericality: { in: 1..8 }
  validates :current_week, presence: true, numericality: { greater_than_or_equal_to: 1 }
  validates :split_type, presence: true

  before_validation :set_defaults, on: :create

  def muscle_groups_for_session(session_type)
    case split_type
    when "push_pull_legs"
      case session_type
      when "push" then %w[Chest Front\ Delts Side\ Delts Triceps]
      when "pull" then %w[Back Rear\ Delts Biceps]
      when "legs" then %w[Quads Hamstrings Glutes Calves]
      end
    when "upper_lower"
      case session_type
      when "upper" then %w[Chest Back Front\ Delts Side\ Delts Rear\ Delts Biceps Triceps]
      when "lower" then %w[Quads Hamstrings Glutes Calves]
      end
    when "full_body"
      MuscleGroup.pluck(:name)
    end
  end

  private

  def set_defaults
    self.current_week ||= 1
    self.status ||= :active
    self.start_date ||= Date.current
    self.end_date ||= start_date + duration_weeks.weeks if start_date && duration_weeks
  end
end
