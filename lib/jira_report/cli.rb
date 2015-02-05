require 'optparse'

module JiraReport
  # Prepares command line parameters using OptionParser
  class Cli
    attr_reader :username, :ini

    def initialize
      options = parse
      @username = options[:username]
      @ini = options[:ini] ? options[:ini] : "~/.jira-report"
    end

    private

    def parse
      options = {}
      OptionParser.new do |opts|
        opts.banner = 'Usage: jira-report [options]'
        opts.on('-u', '--username username', 'Username to query activity report.') do |u|
          options[:username] = u
        end
        opts.on('-s', '--settings ini', 'Path to init file. ' \
                'USER_HOME/.jira-report is default.') do |s|
          options[:ini] = s
        end
      end.parse!
      options
    end
  end
end
