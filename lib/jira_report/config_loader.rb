require 'parseconfig'

module JiraReport
  # Loads configuration from configuration file.
  class ConfigLoader
    attr_reader :url, :username, :password,
      :period_from, :period_till

    def initialize(path)
      load_config(path)
    end

    def validate

    end

    private

    def load_config(path)
      begin
        config = ParseConfig.new(path)
      rescue Exception => e
        raise RuntimeError.new "Error loading config: #{e}"
      end

      @url = config['url']
      @username = config['username']
      @password = config['password']

      @period_from = config['period_from']
      @period_till = config['period_till']
    end
  end
end
