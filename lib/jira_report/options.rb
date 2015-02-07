require 'optparse'

module JiraReport
  class OptionsText
    TEXT = {
      username: 'Specify jira username to query statistic about.',
      config:   'Specify configuration file.',
      version:  'Display version.'
    }
  end

  class Options

    def initialize(args=ARGV)
      @options = parse(args)
    end

    def get(sym)
      @options[sym]
    end

    def include?(sym)
      @options.include? sym
    end

    private

    def parse(args)
      OptionParser.new do |opts|
        opts.banner = 'Usage: jira-report [options]'

        option(opts, '-u', '--username USERNAME')
        option(opts, '-c', '--config FILE')
        option(opts, '-v', '--version')
      end.parse(args)
    end

    def option(opts, *args)
      #TODO:
    end

    def long_opt_sym(*args)
      long_opt = args.find{ |a| a.start_with? '--' }
      long_opt[2..-1].sub(/ .*/, '').gsub('-', '_').sym
    end
  end
end
