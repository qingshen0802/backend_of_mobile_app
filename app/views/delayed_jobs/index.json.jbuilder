json.array!(@delayed_jobs) do |delayed_job|
  json.extract! delayed_job, :id, :priority, :attempts, :handler, :last_error, :run_at, :locked_at, :failed_at, :locked_by, :queue, :created_at, :updated_at
  json.url delayed_job_url(delayed_job, format: :json)
end
