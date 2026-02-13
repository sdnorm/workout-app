module RpPeriodization
  extend ActiveSupport::Concern

  # RIR targets by week of mesocycle
  RIR_PROGRESSION = {
    1 => 3, # Week 1: 3 RIR (conservative)
    2 => 2, # Week 2: 2 RIR (moderate)
    3 => 1, # Week 3: 1 RIR (hard)
    4 => 0  # Week 4: 0 RIR (near failure)
  }.freeze

  DELOAD_RIR = 4

  def target_rir
    return DELOAD_RIR if deloading?
    RIR_PROGRESSION.fetch(current_week, 1)
  end

  def advance_week!
    return if completed?

    if current_week >= duration_weeks
      update!(status: :completed)
    else
      new_week = current_week + 1
      update!(current_week: new_week)
      progress_volumes!(new_week)
    end
  end

  def start_deload!
    update!(status: :deloading)
    mesocycle_volumes.each do |mv|
      mv.update!(current_sets: mv.mev)
    end
  end

  def initialize_volumes!
    MuscleGroup.find_each do |mg|
      mesocycle_volumes.create!(
        muscle_group: mg,
        starting_sets: mg.default_mev,
        current_sets: mg.default_mev,
        mev: mg.default_mev,
        mav: ((mg.default_mev + mg.default_mrv) / 2.0).round,
        mrv: mg.default_mrv
      )
    end
  end

  def volume_summary
    mesocycle_volumes.includes(:muscle_group).map do |mv|
      {
        muscle_group: mv.muscle_group.name,
        current_sets: mv.current_sets,
        mev: mv.mev,
        mrv: mv.mrv,
        week_volume: mv.volume_for_week(current_week)
      }
    end
  end

  private

  def progress_volumes!(week)
    mesocycle_volumes.each do |mv|
      increment = week <= 2 ? 1 : 2
      new_sets = [ mv.current_sets + increment, mv.mrv ].min
      mv.update!(current_sets: new_sets)
    end
  end
end
