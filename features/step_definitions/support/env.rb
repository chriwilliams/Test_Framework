require 'MediTAF'
require 'capybara'
require 'site_prism'
require 'capybara/cucumber'
require 'capybara/poltergeist'
require 'csv'
require_relative 'helper_methods'

World(MediTAF)

Before do |cuke_config|
  $config = MediTAF::Utils::Configuration.new
  $applications = MediTAF::UI.new if $config['ui']
  $services ||= MediTAF::Services.new if $config['services']
  $faker = MediTAF::Utils::MediTAFFaker
  $sticky ||= MediTAF::Utils::Sticky.new
  $helpers = MIST::HelperMethods
  $fix_randoms = {}
end


After ('~@janus_service') do |scenario|
  if scenario.failed?
    $applications.current_app.current_page.take_screenshot if $applications.current_app
    sleep 1
  end
  $applications.close if $applications
  Capybara.session_name = nil
  Capybara.reset_sessions!
  Capybara.reset!
  sleep 1
end

After ('@janus_service') do
  $client_division.clean if $client_division
end
