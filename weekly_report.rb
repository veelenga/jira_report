require 'rest_client'
require 'json'
require 'uri'
require 'inifile'
require 'optparse'

class WeeklyReport

  attr_reader :search_url, :username

  def initialize(search_url, username)
    @search_url = search_url
    @username = username
  end

  def weekly_report
    puts "Quering jira..."

    weekly_created = created('-1w')
    weekly_resolved = resolved('-1w')
    weekly_reopened = reopened('-1w')
    weekly_closed = closed('-1w')

    puts "Last week activities report in Jira for [#{@username}]:"

    puts "\nCreated: #{weekly_created.length}"
    print_issues(weekly_created)

    puts "\nResolved: #{weekly_resolved.length}"
    print_issues(weekly_resolved)

    puts "\nReopened: #{weekly_reopened.length}"
    print_issues(weekly_reopened)

    puts "\nClosed: #{weekly_closed.length}"
    print_issues(weekly_closed)
  end

  private
  def created(time)
    search_issues("jql=created>=#{time} AND reporter in (#{@username})")
  end

  private
  def resolved(time)
    search_issues("jql=resolved>=#{time} AND 'First Resolution User' in (#{@username})")
  end

  private 
  def closed(time)
    search_issues("jql='First Closed Date'>=#{time} AND 'First Closed User' in (#{@username})")
  end

  private 
  def reopened(time)
    search_issues("jql='First Reopened Date'>=#{time} AND 'First Reopened User' in (#{@username})")
  end

  private
  def search_issues(filter)
    response = RestClient.get(@search_url + URI.escape(filter))
    if(response.code != 200)
      raise "Error with the http request!"
    end
    data = JSON.parse(response.body)['issues']
  end

  private
  def print_issues(issues)
    issues.each do |issue|
      puts "  #{issue['key']} - #{issue['fields']['summary']}"
    end
  end
end


class CmdUtils
  def read_input_parameters
    options = {}
    OptionParser.new do |opts|
      opts.banner = "Usage: weekly_report.rb [options]"
      opts.on("-u", "--username username", "Username to get weekly jira statistic on") do |username|
        options[:username] = username
      end
      opts.on("-s", "--settings path_to_settings",
              "Specifies path to your settings file. Not mandatory. settings.ini used by default") do |file_path|
        options[:file_path] = file_path
      end
    end.parse!

    raise OptionParser::MissingArgument, 'username should be specified' if options[:username].nil?
    options
  end
end

options = CmdUtils.new.read_input_parameters

username = options[:username]
if options[:file_path]
  file_with_settings = options[:file_path]
else
  file_with_settings = 'settings.ini'
end

settings = IniFile.load(file_with_settings)
if not settings
  raise RuntimeError, "File #{file_with_settings} to initialize properties not found"
end

jusername = settings['jira']['username']
jpassword = settings['jira']['password']
jurl      = settings['jira']['url']

WeeklyReport.new("http://#{jusername}:#{jpassword}@#{jurl}/rest/api/2/search?", "#{username}").weekly_report
