require "test_helper"

class TrainingMethodologyTest < ActiveSupport::TestCase
  setup do
    @methodology = training_methodologies(:rp_default)
    @inactive = training_methodologies(:custom_inactive)
    @user = users(:one)
  end

  test "valid methodology" do
    assert @methodology.valid?
  end

  test "requires name" do
    @methodology.name = nil
    assert_not @methodology.valid?
    assert_includes @methodology.errors[:name], "can't be blank"
  end

  test "requires content" do
    @methodology.content = nil
    assert_not @methodology.valid?
    assert_includes @methodology.errors[:content], "can't be blank"
  end

  test "belongs to user" do
    assert_equal @user, @methodology.user
  end

  test "active scope returns only active methodologies" do
    active = @user.training_methodologies.active
    assert_includes active, @methodology
    assert_not_includes active, @inactive
  end

  test "activate! deactivates others and activates self" do
    assert @methodology.active?
    assert_not @inactive.active?

    @inactive.activate!

    assert @inactive.reload.active?
    assert_not @methodology.reload.active?
  end

  test "activate! works when already active" do
    @methodology.activate!
    assert @methodology.reload.active?
  end

  test "user active_training_methodology returns active one" do
    assert_equal @methodology, @user.active_training_methodology
  end

  test "user active_training_methodology returns nil when none active" do
    @user.training_methodologies.update_all(active: false)
    assert_nil @user.active_training_methodology
  end
end
