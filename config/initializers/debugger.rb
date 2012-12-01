if ENV["debugger"] == "true" and [ nil, "1" ].include? ENV["UNICORN_WORKERS"]
  Debugger.wait_connection = true
  Debugger.start_remote
end
