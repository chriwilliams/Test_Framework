module ShamusHelper

  # Attempts to upload and link downloaded file with columbo for Shamus report. The content of the downloaded folder is removed once done.
  if Object.const_defined?('Shamus')
    Shamus.after_scenario do |scenario|
      if scenario.tags.include?('@export')
        FileUtils.copy(
            DownloadHelper.download,
            Shamus.current.current_step.add_inline_asset($config['ui']['capybara']['download_ext'], Shamus::Cucumber::InlineAssets::RENDER_AS_LINK))
      end
    end
  end

  # prints text to console or shamus output
  # @param text [string] the text you want to print to the console or shamus output
  def print_to_output(text)
    if Object.const_defined?('Shamus')
      asset = Shamus.current.current_step.add_inline_asset('.txt', Shamus::Cucumber::InlineAssets::RENDER_AS_TEXT)
      File.open(asset, 'w') { |f| f.puts("#{text}") }
    end
  end
end

World(ShamusHelper)
