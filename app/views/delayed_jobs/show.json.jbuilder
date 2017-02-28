json.extract! @delayed_job, :id, :priority, :attempts, :handler, :last_error, :run_at, :locked_at, :failed_at, :locked_by, :queue, :created_at, :updated_at
