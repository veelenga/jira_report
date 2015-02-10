require 'parseconfig'

module JiraReport
  # Loads configuration from configuration file.
  class ConfigLoader
    def self.load_config(path)
      begin
        ParseConfig.new(File.expand_path(path)).params
      rescue Exception => e
        raise RuntimeError.new "Error loading config: #{e}"
      end
    end
  end
end
