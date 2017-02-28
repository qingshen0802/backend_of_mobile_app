raise "Config file should presents" unless File.exists?("#{RAILS_ROOT}/config/config.yml")

Rails::Application.configure do
  config.settings = YAML.load_file("#{RAILS_ROOT}/config/config.yml")[RAILS_ENV]
end
