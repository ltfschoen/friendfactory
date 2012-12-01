if ENV["debugger"] == "true"
  Debugger.wait_connection = true
  Debugger.start_remote
end
