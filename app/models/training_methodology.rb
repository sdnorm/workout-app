class TrainingMethodology < ApplicationRecord
  belongs_to :user

  validates :name, :content, presence: true

  scope :active, -> { where(active: true) }

  def activate!
    transaction do
      user.training_methodologies.where.not(id: id).update_all(active: false)
      update!(active: true) unless active?
      reload
    end
  end
end
