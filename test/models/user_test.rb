require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "downcases and strips email_address" do
    user = User.new(email_address: " DOWNCASED@EXAMPLE.COM ")
    assert_equal("downcased@example.com", user.email_address)
  end

  test "training_experience enum" do
    user = users(:one)
    assert user.intermediate?
    user.training_experience = :advanced
    assert user.advanced?
  end

  test "active_mesocycle returns active mesocycle" do
    user = users(:one)
    assert_equal mesocycles(:active), user.active_mesocycle
  end

  test "default_provider_model for anthropic" do
    user = users(:one)
    assert_equal "claude-sonnet-4-5-20250929", user.default_provider_model
  end

  test "default_provider_model for xai" do
    user = users(:one)
    user.default_provider = "xai"
    assert_equal "grok-3-mini", user.default_provider_model
  end
end
