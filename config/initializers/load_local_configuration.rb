if RAILS_ENV == "development"
  local_configuration = File.expand_path(RAILS_ROOT + "/.local_configuration")
  eval(File.read(local_configuration), binding) if File.exist?(local_configuration)
end