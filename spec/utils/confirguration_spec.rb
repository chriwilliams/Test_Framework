require_relative '../spec_helper'

describe MediTAF::Utils::Configuration do

  it 'should read a valid configuration file' do
    expect { MediTAF::Utils::Configuration.new('./config/MediTAF_config.yml') }.to_not raise_error
  end

  it 'should find the default configuration file i.e. MediTAF_config.yml' do
    expect { MediTAF::Utils::Configuration.new }.to_not raise_error
  end

  it 'should raise an error when no configuration file is found' do
    expect { MediTAF::Utils::Configuration.new('unknown_config.yml') }.to raise_error MediTAF::Utils::Configuration::FileNotFound
  end

  it 'should raise an error when the configuration file is empty' do
    expect { MediTAF::Utils::Configuration.new('./spec/utils/empty_config.yml') }.to raise_error MediTAF::Utils::Configuration::FileEmpty
  end

  it 'should raise an error when the configuration file contains invalid YAML syntax' do
    expect { MediTAF::Utils::Configuration.new('./spec/utils/bad_config.yml') }.to raise_error MediTAF::Utils::Configuration::Error
  end

  it %q{should support Configuration['modules'] with reference to 'modules'} do
    MediTAF::Utils::Configuration.new
    expect(MediTAF::Utils::Configuration['modules']).to be_a MediTAF::Utils::Configuration::Settings
  end

  it %q{should support Configuration['services'] without reference to 'modules'} do
    expect(MediTAF::Utils::Configuration.new['services']).to be_a MediTAF::Utils::Configuration::Settings
  end

  it %q{should support $config['modules'] with reference to 'modules'} do
    expect(MediTAF::Utils::Configuration.new['modules']).to be_a MediTAF::Utils::Configuration::Settings
  end

  it %q{should support $config['services'] without referece to 'modules'} do
    expect(MediTAF::Utils::Configuration.new['services']).to be_a MediTAF::Utils::Configuration::Settings
  end

  it %q{should return a sub-collection} do
    expect(MediTAF::Utils::Configuration.new['services']['euresource']).to be_a MediTAF::Utils::Configuration::Settings
  end

  it %q{should return a value from a key} do
    expect(MediTAF::Utils::Configuration.new['services']['adapters']).to be_a String
  end

  it %q{should return nil for an unknown setting} do
    expect(MediTAF::Utils::Configuration.new['s']).to be_nil
  end
end