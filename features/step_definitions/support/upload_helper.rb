require 'fileutils'

module UploadHelper

  attr_reader :path, :dir

  # @return [String] the file path chosen based on configuration data
  def self.path
    @path = @dir ? @dir : $feature_data_dir
  end

  # The source path for the file you are uploading
  def self.set(dir)
    unless dir.nil?
      @dir = File.join(Dir.pwd, dir) if Dir.exist?(dir)
    end
  end

end

World(UploadHelper)

Before do |cuke_config|
  $feature_data_dir = "#{cuke_config.feature.file.gsub('.feature', '_data')}"
end
