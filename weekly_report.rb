require 'rest_client'
require 'json'
require 'uri'
require 'inifile'

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

settings = IniFile.load('settings.ini')
if not settings
  raise RuntimeError("File 'settings.ini' to initialize properties not found")
end
username = settings['jira']['username']
password = settings['jira']['password']
url      = settings['jira']['url']

search_url = "http://#{username}:#{password}@#{url}/rest/api/2/search?"
r = WeeklyReport.new(search_url, 'veelenga')
r.weekly_report
