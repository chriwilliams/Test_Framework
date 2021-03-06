require_relative '../spec_helper'

class ExceptionTest < MediTAF::Utils::Exceptions::MediTAFException; end

describe MediTAF::Utils::Exceptions::MediTAFException do
  let (:logfile) { $config['logging']['filepath'] }

  before (:each) do
    $config = MediTAF::Utils::Configuration.new
    logfile = $config['logging'].send(:[]=, 'filepath', './spec/utils/logging.txt')
    File.delete(logfile) if File.file?(logfile)
  end

  after (:each) do
    File.delete(logfile)
    MediTAF::Utils::Logger.loggers.clear
  end

  it 'should log a default error message with the class name' do
    ExceptionTest.new
    lines = File.open(logfile, 'r').readlines
    expect(lines.count).to eq(1)
    expect(lines[0]).to match(/.*ExceptionTest: MediTAF Exception$/)
  end

  it 'should log a specific error message' do
    msg = 'the specific message'
    ExceptionTest.new(msg)
    lines = File.open(logfile, 'r').readlines
    expect(lines.count).to eq(1)
    expect(lines[0]).to match(/.*ExceptionTest: #{msg}$/)
  end
end