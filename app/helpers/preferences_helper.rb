module PreferencesHelper
  def priority_badge_class(priority)
    case priority
    when "priority"
      "bg-blue-900/50 text-blue-300 border-blue-700"
    when "maintenance"
      "bg-yellow-900/50 text-yellow-300 border-yellow-700"
    else
      "bg-gray-800 text-gray-400 border-gray-700"
    end
  end
end
