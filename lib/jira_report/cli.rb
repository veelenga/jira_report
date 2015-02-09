require 'jira_report/options'
require 'jira_report/config_loader'
require 'jira_report'

module JiraReport
  class Cli
    DEFAULT_CONFIG_PATH = '~/.jira-report'

    def run(args=ARGV)
      options = Options.new(args).options
      act_on_option(options)

      load_config(options[:config])
      ask_missing_options
      add_usr(options[:username])

      JiraReport.new(@config)
      #TODO: print report to console
    end

    private

    # Does required actions on specified option if needed.
    def act_on_option(options)
      if options.include? :version
        puts VERSION
        exit(0)
      end
      # ...
    end

    # Loads configuration from configuration file.
    def load_config(path)
      config_path = path ? path : DEFAULT_CONFIG_PATH
      @config = ConfigLoader.load_config(config_path)
    end

    # Reads required options from user input if those
    # were missed.
    def ask_missing_options
      # TODO:
      # update @config
    end

    # Adds to config username to query about.
    def add_usr(usr)
      if usr
        @config[:usr] = usr
      else
        # use username for authentication if username
        # to query not specified.
        @config[:usr] = config[:username]
      end
    end
  end
end
