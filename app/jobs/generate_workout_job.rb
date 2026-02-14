class GenerateWorkoutJob < ApplicationJob
  queue_as :default

  def perform(workout)
    generator = Workout::Generator.new(user: workout.user, workout: workout)
    if generator.generate
      workout.update!(status: :planned)
    else
      workout.update!(status: :generation_failed, generation_error: generator.errors.full_messages.join(", "))
    end
  rescue => e
    workout.update!(status: :generation_failed, generation_error: e.message)
  end
end
