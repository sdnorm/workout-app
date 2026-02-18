class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :mesocycles, dependent: :destroy
  has_many :workouts, dependent: :destroy
  has_many :runs, dependent: :destroy
  has_many :mobility_routines, dependent: :destroy
  has_many :chats, dependent: :destroy
  has_one :preference, class_name: "UserPreference", dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  enum :training_experience, { beginner: 0, intermediate: 1, advanced: 2 }

  def active_mesocycle
    mesocycles.active.order(created_at: :desc).first
  end

  def default_provider_model
    case default_provider
    when "xai" then "grok-3-mini"
    else "claude-sonnet-4-5-20250929"
    end
  end
end
