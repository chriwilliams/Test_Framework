require 'fileutils'

module DownloadHelper
  attr_reader :dir, :path
  extend self
  begin
    TIMEOUT ||= 30
  end

  # @return [String] the file path chosen based on configuration data
  def self.path
    @path = ($config['ui']['capybara']['download_dir'] || ENV["DOWNLOAD_DIR"])
  end

  # Creates a new path directory unless one exists
  def self.set
    Dir.mkdir_p(@path) unless File.exist? @path
  end

  # @return [String] File and Folder contents from the path
  def self.downloads
    Dir[File.join(@path, '*')]
  end

  # @return [String] current directory or first data found in path
  def self.download
    @dir || downloads.first
  end

  # @return [String] Read output content of file
  def self.download_content
    wait_for_download
    File.read(download)
  end

  # Waiter method to ensure file is fully downloaded
  def self.wait_for_download
    Timeout.timeout(TIMEOUT) do
      sleep 0.1 until downloaded?
    end
  end

  # @return [Boolean] returns true/false whether file download is complete
  def self.downloaded?
    downloads.any? && !downloading?
  end

  # @return [Boolean] download progress status
  def self.downloading?
    downloads.grep(/\.crdownload$/).any?
  end

  # Clears all contents from path
  def self.clear_downloads
    FileUtils.rm_f(downloads)
  end

  # Creates a new directory in path
  def self.new_download_dir
    @dir = File.join(path, UUIDTools::UUID.random_create.to_s)
    FileUtils.mkdir_p @dir
  end

end
World(DownloadHelper)

Before('@export') do
  @dir = nil
  path = DownloadHelper.path
  FileUtils.mkdir_p(path) unless File.exist? path
end

# Ensuring the Download folder is empty before method starts
Before('@studydesign', '@export') do
  DownloadHelper.clear_downloads
end
