require 'optparse'

module JiraReport

  # Collection of input argument descriptions.
  class OptionsText
    TEXT = {
      username: 'Specify jira username to query statistic about.',
      config:   'Specify path to configuration file.',
      version:  'Display version.'
    }
  end

  # Parses and validates array of input arguments.
  class Options
    # Accepts arguments to be parsed.
    # Raises ArgumentError if args is not kind of Array.
    def initialize(args=ARGV)
      unless args.kind_of? Array
        raise ArgumentError.new "Array expected, but was #{args.class}"
      end
      @options = {}
      parse(args)
    end

    # Returns clone of option hash
    def options
      @options.dup
    end

    # Returns option from option list with name that converted
    # to symbol.
    def get(sym)
      @options[sym]
    end

    # Returns true if option list includes option which name
    # converted to symbol.
    def include?(sym)
      @options.include? sym
    end

    private

    # Parses args. Adds parsed argument to option hash
    # in next format:
    #   :option_name => option
    # Where :option_name - corresponding symbol of
    # option name.
    def parse(args)
      OptionParser.new do |opts|
        opts.banner = 'Usage: jira-report [options]'

        option(opts, '-u', '--username USERNAME')
        option(opts, '-c', '--config FILE')
        option(opts, '-v', '--version')
      end.parse!(args)
    end

    # Adds new option.
    def option(opts, *args)
      opt_sym = long_opt_sym(*args)
      args << OptionsText::TEXT[opt_sym]
      opts.on(*args) { |arg| @options[opt_sym] = arg }
    end

    # Looks through arg list to find long option
    # and converts it to sym. Assumes that long
    # option always present.
    #
    # For example:
    #  ['-c', '--config-file FILE'] => :config_file
    def long_opt_sym(*args)
      long_opt = args.find{ |arg| arg.start_with? '--' }
      long_opt[2..-1].sub(/ .*/, '').gsub('-', '_').to_sym
    end
  end
end
