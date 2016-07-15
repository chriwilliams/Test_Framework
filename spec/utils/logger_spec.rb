require_relative '../spec_helper'

class LogTest1
  include FirstFramework::Utils::Logger
end

class LogTest2
  include FirstFramework::Utils::Logger
end

class LogTest3
  include FirstFramework::Utils::Logger
end

describe FirstFramework::Utils::Logger do
  let (:logfile) { $config['logging']['filepath'] }

  before (:each) do
    $config = FirstFramework::Utils::Configuration.new
    @config = $config['logging']
    @config.send :[]=, 'filepath', './spec/utils/logging.txt'
    File.delete(@config['filepath']) if File.file?(@config['filepath'])
  end

  after (:each) do
    File.delete(@config['filepath']) if @config['filepath'] && File.file?(@config['filepath'])
    Logging.shutdown
    FirstFramework::Utils::Logger.loggers.clear
  end

  it 'should log to a specific file' do
    log = FirstFramework::Utils::Logger.configure_logger_for(LogTest1)
    expect(log.appenders.detect {|a| a.name == @config['filepath'] }).not_to be_nil
    expect(File.new(@config['filepath'])).not_to be_nil
  end

  it 'should use a hash class-ivar to cache a unique Logger per class' do
    current_count = FirstFramework::Utils::Logger.loggers.size
    1.upto(3) do |i|
      FirstFramework::Utils::Logger.logger_for("LogTest#{i}".constantize)
      expect(FirstFramework::Utils::Logger.loggers.size).to eq( i + current_count )
    end
  end

  context 'when included' do
    it 'log should get self' do
      expect(LogTest1.new.log.name).to eq('LogTest1')
    end
  end

  context 'when missing configuration items, it should raise an error' do
    subject { FirstFramework::Utils::Logger.configure_logger_for(LogTest1) }

    it 'should raise a LoggingConfigurationMissing' do
      $config.send :delete, 'logging'
      expect { subject }.to raise_error FirstFramework::Utils::Logger::LoggingConfigurationMissing
    end

    it 'should raise a LoggingFilePathMissing' do
      @config.send :[]=, 'filepath', nil
      expect { subject }.to raise_error FirstFramework::Utils::Logger::LoggingFilePathMissing
    end

    it 'should raise a LoggingLevelMissing' do
      @config.send :[]=, 'level', nil
      expect { subject }.to raise_error FirstFramework::Utils::Logger::LoggingLevelMissing
    end
  end
end