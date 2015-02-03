require 'rest_client'
require 'json'
require 'uri'

require 'jira_report/settings'
require 'jira_report/cli'

# Generates report based on activities in jira
module JiraReport
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
end
