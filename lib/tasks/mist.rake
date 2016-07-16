$LOAD_PATH.unshift File.dirname(__FILE__)

begin
  puts "Starting MIST rake..."

  puts "Rails Environment is set to test by default"
  ENV["RAILS_ENV"] ||='test'
  dir = File.expand_path("..", File.expand_path("..", File.dirname(__FILE__)))
  ENV["DOWNLOAD_DIR"] ||= File.join(dir, 'tmp', 'download')
  ENV["DOWNLOAD_EXT"] ||= ".csv"
end

namespace :mist do
  desc 'Setup a Jenkins job to execute the MIST feature files'

  desc 'All: this task calls "mist:install" for prestine installations and "mist:config"'
  task :all do
    begin
      Rake::Task["mist:install"].invoke

      Rake::Task["mist:config"].invoke
    rescue
      puts "Failure to execute rake task 'mist:all'"
    end

  end

  desc 'config: task to config dice files and generate yml'
  task :config do
    begin
      ENV["BROWSER"]||=':firefox'
      ENV["DRIVER"]||=':selenium'
      ENV["RUN_SERVER"]||='false'
      ENV["DEFAULT_WAIT_TIME"]||='40'
      ENV["DEFAULT_SELECTOR"]||=':css'
      ENV["APP_HOST"]||='https://login-validation.imedidata.net'
      ENV["APP"]||=nil
      ENV["CUCUMBER_TAGS"] ||= nil
      ENV["CUCUMBER_FORMAT"] ||= nil
      ENV["CUCUMBER_STEPS"] ||= 'features/step_definitions'
      ENV["MAUTH_API_VERSION"]||='v1'
      #ENV["AUTHENTICATE_VERSION"]||=false
      ENV["WIDTH"] ||= '1280'
      ENV["HEIGHT"] ||= '1024'
      ENV["PRINT_STICKY"] ||= 'true'

      ENV["PRODUCT"] ||= 'MIST'
      ENV["RELEASE"] ||= `git describe --abbrev=0 --tags`
      ENV["PROFILE"] ||= 'validation'

      ENV["LOG_LEVEL"] ||= 'debug'
      create_logger

    rescue
      puts "Failure to execute rake task 'mist:config'"
    end
    Rake::Task["config"].invoke
  end

  desc 'install: task to install gem within projects'
  task :install do
    begin
      Bundler.with_clean_env do
        sh "rm Gemfile.lock"
      end
      puts "Install gems through 'bundle install'"
    end
    Bundler.with_clean_env do
      sh "bundle install"
    end
  end

  desc 'docs: task to generate documentation for pages'
  task :docs do
    begin
      sh "yardoc --protected 'pages/**/*.rb'"
    end
  end

  private

  def create_logger
    begin
      require 'rbconfig'
      include RbConfig

      filepath = nil
    end
    case CONFIG['host_os']
      when /mswin|windows/i
        path = "c:\\temp"
        filepath = "#{path}\\"
        system "mkdir #{path} &"
      when /linux|arch/i
        path = "tmp/log"
        filepath = "#{path}/"
        system "mkdir -p #{path} &"
      when /sunos|solaris/i
        path = "tmp/log"
        filepath = "#{path}/"
        system "mkdir -p #{path} &"
      when /darwin/i
        path = "tmp/log"
        filepath = "#{path}/"
        system "mkdir -p #{path} &"
      #when /linux|arch/i || /sunos|solaris/i || /darwin/i
      #  path = "tmp/log"
      #  filepath = "#{path}/"
      #  system "mkdir -p #{path} &"
      else
        puts "no file path"
        filepath = nil
    end

    ENV["LOG_FILE"] ||= filepath ? "#{filepath}MediTAF.log" : nil
  end

end

