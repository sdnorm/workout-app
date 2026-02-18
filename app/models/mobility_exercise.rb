class MobilityExercise < ApplicationRecord
  belongs_to :mobility_routine

  validates :name, presence: true
  validates :position, presence: true

  def duration_display
    return nil unless duration_seconds.present? && duration_seconds > 0
    if duration_seconds >= 60
      "#{duration_seconds / 60}:#{format('%02d', duration_seconds % 60)}"
    else
      "#{duration_seconds}s"
    end
  end

  def prescription_display
    parts = []
    parts << "#{sets} sets" if sets.present? && sets > 0
    parts << "#{reps} reps" if reps.present? && reps > 0
    parts << "#{hold_seconds}s hold" if hold_seconds.present? && hold_seconds > 0
    parts << "each side" if side.present? && side != "bilateral"
    parts.join(" x ")
  end
end
