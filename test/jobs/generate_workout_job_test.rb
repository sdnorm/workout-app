require "test_helper"

class GenerateWorkoutJobTest < ActiveJob::TestCase
  setup do
    @workout = workouts(:planned_gym)
    @workout.update!(status: :generating)
  end

  test "sets status to planned on success" do
    generator = FakeGenerator.new(result: true)
    Workout::Generator.stub_new(generator) do
      GenerateWorkoutJob.perform_now(@workout)
    end

    assert @workout.reload.planned?
  end

  test "sets status to generation_failed on generator failure" do
    generator = FakeGenerator.new(result: false, error_message: "Something went wrong")
    Workout::Generator.stub_new(generator) do
      GenerateWorkoutJob.perform_now(@workout)
    end

    @workout.reload
    assert @workout.generation_failed?
    assert_equal "Something went wrong", @workout.generation_error
  end

  test "sets status to generation_failed on exception" do
    generator = FakeGenerator.new(raise_error: "API timeout")
    Workout::Generator.stub_new(generator) do
      GenerateWorkoutJob.perform_now(@workout)
    end

    @workout.reload
    assert @workout.generation_failed?
    assert_equal "API timeout", @workout.generation_error
  end

  class FakeGenerator
    def initialize(result: true, error_message: nil, raise_error: nil)
      @result = result
      @error_message = error_message
      @raise_error = raise_error
    end

    def generate
      raise @raise_error if @raise_error
      @result
    end

    def errors
      @errors ||= begin
        e = ActiveModel::Errors.new(self)
        e.add(:base, @error_message) if @error_message
        e
      end
    end

    def self.human_attribute_name(attr, _options = {}) = attr.to_s
    def self.lookup_ancestors = []
  end
end

# Reopen to add test helper
class Workout::Generator
  def self.stub_new(fake_instance)
    original = method(:new)
    define_singleton_method(:new) { |**_| fake_instance }
    yield
  ensure
    define_singleton_method(:new, original)
  end
end
