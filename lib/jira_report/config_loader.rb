require 'parseconfig'

module JiraReport
  # Loads configuration from configuration file.
  class ConfigLoader
    def self.load_config(path)
      begin
        config = ParseConfig.new(File.expand_path(path))
        symboled_hash(config.params)
      rescue Exception => e
        raise RuntimeError.new "Error loading config: #{e}"
      end
    end

    private

    def self.symboled_hash(h)
      h.inject({}){ |m, (k,v)| m[k.to_sym] = v; m }
    end
  end
end
