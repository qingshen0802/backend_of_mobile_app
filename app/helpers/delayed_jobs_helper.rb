module DelayedJobsHelper
  def last_error_tag(delayed_job)
  	if delayed_job.last_error
  	  delayed_job.last_error.split("\n").join("</br>")
  	else
  	  ''
  	end.html_safe
  end
end
