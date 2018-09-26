def systemctl?
  ENV["PATH"].split(":").any? { |dir| File.exists?(File.join(dir, "systemctl")) }
end

def systemd_running?
  IO.popen(["systemctl", "is-system-running"], &:read).chomp == "online"
end

def background_worker(state)
  ensure!(:background_worker)
  ensure!(:application_name)
  comment %(#{state}ing #{background_worker_name})
  if systemctl? && systemd_running?
    command %(sudo systemctl #{state} #{background_worker_name})
  else
    command %(sudo #{state} #{background_worker_name})
  end
end

def background_worker_name
  [fetch(:background_worker), fetch(:application_name), fetch(:rails_env)].join('-')
end
