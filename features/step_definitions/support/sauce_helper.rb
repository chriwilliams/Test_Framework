
# Load Sauce Config
sauce_config_file = Dir.glob(File.join("**", "sauce_config.yml")).first
if sauce_config_file
  sauce_config = YAML.load_file(sauce_config_file)

  if sauce_config['use_sauce_labs']

    require 'sauce'
    require 'sauce/capybara'
    require 'sauce/cucumber'

    $using_saucelabs = true
    max_platforms = sauce_config['max_platforms'].to_i - 1

    browsers = []
    sauce_config['os_browser_version'].each do |item|
      temp_arr = [item['os'].to_s, item['browser'].to_s, item['version'].to_s]
      browsers.push temp_arr
    end

    browsers = browsers.empty? ? browsers : browsers[0..max_platforms]
    Sauce.config do |config|
      config[:browsers] = browsers
      config[:start_tunnel] = sauce_config['start_tunnel']
    end
  end
end
