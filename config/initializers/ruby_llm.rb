RubyLLM.configure do |config|
  config.anthropic_api_key = ENV["ANTHROPIC_API_KEY"]
  config.xai_api_key = ENV["XAI_API_KEY"]

  config.use_new_acts_as = true
end
