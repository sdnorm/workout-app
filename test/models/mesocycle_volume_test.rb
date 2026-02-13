require "test_helper"

class MesocycleVolumeTest < ActiveSupport::TestCase
  test "validates required fields" do
    mv = MesocycleVolume.new(mesocycle: mesocycles(:active), muscle_group: muscle_groups(:chest))
    assert_not mv.valid?
  end

  test "volume_for_week returns mev when deloading" do
    meso = mesocycles(:active)
    meso.start_deload!
    mv = mesocycle_volumes(:chest_active)
    assert_equal mv.mev, mv.volume_for_week(1)
  end

  test "volume_for_week clamps to mev-mrv range" do
    mv = mesocycle_volumes(:chest_active)
    volume = mv.volume_for_week(1)
    assert volume >= mv.mev
    assert volume <= mv.mrv
  end
end
