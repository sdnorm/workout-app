class GenerateMobilityRoutineJob < ApplicationJob
  queue_as :default

  def perform(mobility_routine)
    generator = MobilityRoutine::Generator.new(user: mobility_routine.user, mobility_routine: mobility_routine)
    if generator.generate
      mobility_routine.update!(status: :logged)
    else
      mobility_routine.update!(status: :generation_failed, generation_error: generator.errors.full_messages.join(", "))
    end
  rescue => e
    mobility_routine.update!(status: :generation_failed, generation_error: e.message)
  end
end
