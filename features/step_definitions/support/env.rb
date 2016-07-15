require 'simplecov'
SimpleCov.command_name 'Cucumber'

require 'MediTAF'
require 'capybara'
require 'site_prism'
require 'capybara/cucumber'  # This resets Capybara session

AfterConfiguration do
  $config = MediTAF::Utils::Configuration.new

  # Configure Capybara
  if $config['ui']['capybara']
    capybara_config = $config['ui']['capybara']
    Capybara.configure do |config|
      config.default_driver = capybara_config['default_driver']
      config.run_server = capybara_config['run_server']
      config.default_selector = capybara_config['default_selector']
      config.app_host = capybara_config['app_host']
      config.app = capybara_config['app']
      config.default_max_wait_time = capybara_config['default_max_wait_time']
    end

    Capybara.register_driver :selenium do |app|
      Capybara::Selenium::Driver.new(app, :browser => $config['ui']['browser'])
    end
  end

  SitePrism.configure do |config|
    config.use_implicit_waits = true
  end

  $applications = MediTAF::UI.new if $config['ui']
  $services = MediTAF::Services.new if $config['services']
  $faker = MediTAF::Utils::MediTAFFaker
  $sticky = MediTAF::Utils::Sticky.new
end

After do
  $applications.close if $applications
  Capybara.session_name = nil
  Capybara.reset_sessions!
  Capybara.reset!
  Capybara.current_session.driver.quit
  sleep 1
end

at_exit do
  Dir['./*'].select { |f| f =~ /^\.\/(main|test)_cfg\d*\.yml$/ }.each { |f| File.delete f }
end
