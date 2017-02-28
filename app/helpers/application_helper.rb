module ApplicationHelper
  def l_with_time_zone(_time, _time_zone='Pacific Time (US & Canada)')
  	l _time.in_time_zone(_time_zone)
  end
end
