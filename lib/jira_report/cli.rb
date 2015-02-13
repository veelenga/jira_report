require 'jira_report/options'
require 'jira_report/config_loader'
require 'jira_report/reporter'
require 'jira_report/version'
require 'io/console'

module JiraReport
  class Cli
    DEFAULT_CONFIG_PATH = '~/.jira-report'

    def initialize
      @config = {}
    end

    def run(args=ARGV)
      begin
        options = Options.new(args).options
        act_on_option(options)

        load_config(options[:config])
        ask_missing_options
        add_usr(options[:username])

        report
      rescue => e
        puts "error: '#{e.message}'"
        exit 1
      rescue SystemExit => e
        exit e.status
      rescue Interrupt => e
        puts 'Interrupted'
        exit 130
      rescue Exception => e
        puts "fatal: '#{e.message}'"
        exit 255
      end
    end

    private

    def report
      reporter = Reporter.new(
        @config[:url], @config[:username], @config[:password]
      )

      puts "\nQuerying jira..."

      created = reporter.created(
        @config[:usr], @config[:period_from], @config[:period_till]
      )
      resolved = reporter.resolved(
        @config[:usr], @config[:period_from], @config[:period_till]
      )
      reopened = reporter.reopened(
        @config[:usr], @config[:period_from], @config[:period_till]
      )
      closed = reporter.closed(
        @config[:usr], @config[:period_from], @config[:period_till]
      )

      puts "\nJira activity report for [#{@config[:usr]}]:"

      puts "\nCreated: #{created.length}"
      print_issues(created)

      puts "\nResolved: #{resolved.length}"
      print_issues(resolved)

      puts "\nReopened: #{reopened.length}"
      print_issues(reopened)

      puts "\nClosed: #{closed.length}"
      print_issues(closed)
    end

    def print_issues(issues)
      issues.each do |issue|
        puts "  #{issue['key']} - #{issue['fields']['summary']}"
      end
    end

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
      begin
        @config = ConfigLoader.load_config(config_path)
      rescue => e
        # Config not loaded from configuration file.
        # Ignore it.
      end
    end

    # Reads required options from user input if those
    # were missed.
    def ask_missing_options
      @config[:url] = ask('Jira url: ') unless @config[:url]
      @config[:username] = ask('Jira username: ') unless @config[:username]
      @config[:password] = ask('Jira password: '){
        STDIN.noecho(&:gets).chomp!
      } unless @config[:password]
      if !@config[:period_from] && !@config[:period_till]
        @config[:period_from] = '-1w'
        @config[:period_till] = 'now()'
      end
    end

    # Asks user to enter something
    def ask(message, &block)
      print message
      if block_given?
        yield block
      else
        gets.chomp!
      end
    end

    # Adds to config username to query about.
    def add_usr(usr)
      if usr
        @config[:usr] = usr
      else
        # use username for authentication if username
        # to query not specified.
        @config[:usr] = @config[:username]
      end
    end
  end
end
