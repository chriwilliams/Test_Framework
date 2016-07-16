locale_config_file = Dir.glob(File.join("**", "locale.yml")).first
if locale_config_file
  $locale_config = YAML.load_file(locale_config_file)
end
