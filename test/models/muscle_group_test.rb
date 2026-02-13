require "test_helper"

class MuscleGroupTest < ActiveSupport::TestCase
  test "validates name presence" do
    mg = MuscleGroup.new(default_mev: 8, default_mrv: 22)
    assert_not mg.valid?
    assert_includes mg.errors[:name], "can't be blank"
  end

  test "validates name uniqueness" do
    mg = MuscleGroup.new(name: "Chest", default_mev: 8, default_mrv: 22)
    assert_not mg.valid?
    assert_includes mg.errors[:name], "has already been taken"
  end

  test "validates mev and mrv are non-negative" do
    mg = MuscleGroup.new(name: "Test", default_mev: -1, default_mrv: 22)
    assert_not mg.valid?
  end
end
