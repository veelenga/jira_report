require 'rest_client'
require 'json'
require 'uri'
require 'inifile'
require 'optparse'

# Generates report based on activities in jira
class JiraReport
  def initialize(init_set, username)
    @username = username
    @search_url = jira_search_url(init_set.jurl,
                                  init_set.jusername,
                                  init_set.jpassword)
  end

  def weekly
    report = report('-1w')

    puts "Last week activities report in Jira for [#{@username}]:"

    puts "\nCreated: #{report[0].length}"
    print_issues(report[0])

    puts "\nResolved: #{report[1].length}"
    print_issues(report[1])

    puts "\nReopened: #{report[2].length}"
    print_issues(report[2])

    puts "\nClosed: #{report[3].length}"
    print_issues(report[3])
  end

  def report(time)
    puts 'Querying jira...'
    [created(time), resolved(time), reopened(time), closed(time)]
  end

  private

  def jira_search_url(url, username, password)
    "http://#{username}:#{password}@#{url}/rest/api/2/search?"
  end

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

# Prepares commad line parameters using OptionParser
class ClParameters
  attr_reader :username, :ini

  def initialize
    options = parse
    fail OptionParser::MissingArgument, 'Specify -u username' \
      unless options[:username]
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

# Reads settings from init file
class Settings
  attr_reader :jusername, :jpassword, :jurl

  def initialize(path)
    settings = read(path)
    parse(settings)
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

    @jusername = jira['username']
    @jpassword = jira['password']
    @jurl      = jira['url']

    fail "Init file hasn't username option!" unless jusername
    fail "Init file hasn't password option!" unless jpassword
    fail "Init file hasn't url option!" unless jurl
  end
end

parameters = ClParameters.new
JiraReport.new(Settings.new(parameters.ini), parameters.username).weekly
