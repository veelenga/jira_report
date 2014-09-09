require 'rest_client'
require 'json'
require 'uri'
require 'inifile'
require 'optparse'

# Generates weekly report based on activities in jira
class WeeklyReport
  attr_reader :search_url, :username

  def initialize(search_url, username)
    @search_url = search_url
    @username = username
  end

  def weekly_report
    puts 'Querying jira...'

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

  def resolved(time)
    search_issues("jql=resolved>=#{time} AND " \
                  "'First Resolution User' in (#{@username})")
  end

  def closed(time)
    search_issues("jql='First Closed Date'>=#{time} " \
                  "AND 'First Closed User' in (#{@username})")
  end

  def reopened(time)
    search_issues("jql='First Reopened Date'>=#{time} " \
                  "AND 'First Reopened User' in (#{@username})")
  end

  def search_issues(filter)
    response = RestClient.get(@search_url + URI.escape(filter))
    fail "Response code #{response.code}" unless response.code == 200
    JSON.parse(response.body)['issues']
  end

  def print_issues(issues)
    issues.each do |issue|
      puts "  #{issue['key']} - #{issue['fields']['summary']}"
    end
  end
end

# Prepares input parameters using OptionParser
class CmdUtils
  attr_reader :username, :ini

  def initialize
    options = parse
    fail OptionParser::MissingArgument, 'Specify username' unless options[:username]
    @username = options[:username]
    @ini = options[:ini] ? options[:ini] : 'settings.ini'
  end

  private

  def parse
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: weekly_report.rb [options]'
      opts.on('-u', '--username username', 'Username to query statistic') do |u|
        options[:username] = u
      end
      opts.on('-s', '--settings ini', 'Path to init file. ' \
              'settings.ini will be used if not specified') do |s|
        options[:ini] = s
      end
    end.parse!
    options
  end
end

# Reads initialize settings from init file
class Settings
  attr_reader :jira_search_url

  def initialize(path)
    settings = read(path)
    @jira_search_url = parse(settings)
  end

  private

  def read(path)
    settings = IniFile.load(path)
    fail "File #{path} not found!" unless settings
    settings
  end

  def parse(settings)
    jira = settings['jira']
    fail "Init file hasn't [jira] section!" unless jira

    jusername = jira['username']
    jpassword = jira['password']
    jurl      = jira['url']

    fail "Init file hasn't username option!" unless jusername
    fail "Init file hasn't password option!" unless jpassword
    fail "Init file hasn't url option!" unless jurl

    "http://#{jusername}:#{jpassword}@#{jurl}/rest/api/2/search?"
  end
end

parameters = CmdUtils.new
settings = Settings.new(parameters.ini)

WeeklyReport.new(settings.jira_search_url, parameters.username).weekly_report
