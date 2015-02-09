require 'parseconfig'

module JiraReport
  # Loads configuration from configuration file.
  class ConfigLoader
    def self.load_config(path)
      begin
        return ParseConfig.new(File.exand_path(path))
      rescue Exception => e
        raise RuntimeError.new "Error loading config: #{e}"
      end
    end
  end
end
