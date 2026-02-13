RubyLLM.configure do |config|
  config.anthropic_api_key = ENV["ANTHROPIC_API_KEY"] || Rails.application.credentials.dig(:anthropic_api_key)
  config.xai_api_key = ENV["XAI_API_KEY"] || Rails.application.credentials.dig(:xai_api_key)

  config.use_new_acts_as = true
end
