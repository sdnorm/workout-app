class MesocycleVolume < ApplicationRecord
  belongs_to :mesocycle
  belongs_to :muscle_group

  validates :starting_sets, :current_sets, :mev, :mrv, presence: true,
    numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def volume_for_week(week)
    return mev if mesocycle.deloading?

    sets_per_week = starting_sets + ((current_sets - starting_sets).to_f / (mesocycle.duration_weeks - 1) * (week - 1)).round
    sets_per_week.clamp(mev, mrv)
  end
end
