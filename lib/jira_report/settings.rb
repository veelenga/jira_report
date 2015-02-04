require 'inifile'
require 'io/console'

# Initializes JiraReport settings.
module JiraReport
  class Settings
    attr_reader :username, :password, :url,\
      :period_from, :period_till

    def initialize(path)
      read(path)
    end

    private

    def read(path)
      loaded = IniFile.load(File.expand_path(path))

      global = loaded[:global] if loaded
      global ||= {}

      @url = global['url']
      @username = global['username']
      @password = global['password']
      @period_from = global['period_from']
      @period_till = global['period_till']

      @url = ask('Jira url: ') unless @url
      @username = ask('Jira username: ') unless @username
      @password = ask('Jira password: '){
        STDIN.noecho(&:gets).chomp!
      } unless @password
      @period_from = '-1w' unless @period_from
      @period_till = 'now()' unless @period_till
    end

    def ask(message, &block)
      print message
      if block
        yield block
      else
        gets.chomp!
      end
    end
  end
end
