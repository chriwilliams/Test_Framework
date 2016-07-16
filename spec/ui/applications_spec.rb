require_relative '../spec_helper'
require 'capybara'
require 'site_prism'

describe MediTAF::UI do
  before (:all) do
    $config = MediTAF::Utils::Configuration.new

    # Configure Capybara
    capybara_config = $config['ui']['capybara']
    Capybara.configure do |config|
      config.default_driver = capybara_config['default_driver']
      config.run_server = capybara_config['run_server']
      config.default_selector = capybara_config['default_selector']
      config.app_host = capybara_config['app_host']
      config.app = capybara_config['app']
      config.default_wait_time = capybara_config['default_wait_time']
    end

    Capybara.register_driver :selenium do |app|
      @driver = Capybara::Selenium::Driver.new(app, :browser => $config['ui']['browser'])
    end

    Capybara.reset!

    SitePrism.configure do |config|
      config.use_implicit_waits = true
    end

    @applications = MediTAF::UI.new
  end

  it 'should instantiate an Applications object' do
    expect(@applications).to be_a MediTAF::UI::Applications
  end

  it 'should load application imedidata' do
    @applications.imedidata
    expect(@applications.apps).to include :imedidata
    expect(@applications.imedidata).to be_a MediTAF::UI::Application
  end

  it 'should raise an error for unknown application' do
    expect { @applications.xyz }.to raise_error MediTAF::UI::AppLoadError
  end

  it 'should load imedidata login page' do
    @applications.imedidata.login
    expect(@applications.imedidata.pages).to include :login
    expect(@applications.imedidata.login).to be_a Common::BasePage
  end

  it 'should raise an error for unknown page' do
    expect { @applications.imedidata.xyz }.to raise_error MediTAF::UI::PageLoadError
  end

  it 'imedidata.login page should respond to username, password, submit, and login' do
    expect(@applications.imedidata.login).to respond_to :username, :password, :submit, :login
  end

  it 'imeiddata.home page should include a section for studies, sites, and teams searches' do
    expect(@applications.imedidata.home).to respond_to :studies_search, :sites_search, :teams_search
  end

  it 'should detect a page as a class in a namespace' do
    @applications.imedidata.login
    expect(@applications.imedidata.inner_login).to be_a Common::BasePage
  end

  it 'should load a page as a class in a namespace' do
    @applications.imedidata.login
    expect(@applications.imedidata.inner_login).to respond_to :inner_method
  end

  after (:all) do
    @applications.close
    Capybara.current_session.driver.quit
  end
end
