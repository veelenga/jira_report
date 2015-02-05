require 'rest_client'
require 'json'
require 'uri'

require 'jira_report/settings'
require 'jira_report/cli'

module JiraReport
  # Base class that generate jira activity report
  class JiraReport
    attr_accessor :from, :till, :username

    def initialize(init_set, username)
      @username = username ? username : 'currentUser()'
      @search_url = jira_search_url(init_set.url,
                                    init_set.username,
                                    init_set.password)

      @from = init_set.period_from
      @till = init_set.period_till
    end

    def report
      puts "\nQuerying jira..."

      created = query(jql_created)
      resolved = query(jql_resolved)
      reopened = query(jql_reopened)
      closed = query(jql_closed)

      puts "\nJira activity report for [#{@username}]:"

      puts "\nCreated: #{created.length}"
      print_issues(created)

      puts "\nResolved: #{resolved.length}"
      print_issues(resolved)

      puts "\nReopened: #{reopened.length}"
      print_issues(reopened)

      puts "\nClosed: #{closed.length}"
      print_issues(closed)
    end

    private

    def jira_search_url(url, username, password)
      "http://#{username}:#{password}@#{url}/rest/api/2/search?"
    end

    def jql_created
      "jql=created>=#{@from} "  \
        "AND created<=#{@till} "\
        "AND reporter=#{@username}"
    end

    def jql_resolved
      "jql=resolved>=#{@from} "  \
        "AND resolved<=#{@till} "\
        "AND 'First Resolution User'=#{@username}"
    end

    def jql_closed
      "jql='First Closed Date'>=#{@from} "  \
        "AND 'First Closed Date'<=#{@till} "\
        "AND 'First Closed User'=#{@username}"
    end

    def jql_reopened
      "jql='First Reopened Date'>=#{@from} "  \
        "AND 'First Reopened Date'<=#{@till} "\
        "AND 'First Reopened User'=#{@username}"
    end

    def query(jql)
      response = RestClient.get(@search_url + URI.escape(jql))
      fail "Query unsuccessful. Response code #{response.code}"\
        unless response.code == 200
      JSON.parse(response.body)['issues']
    end

    def print_issues(issues)
      issues.each do |issue|
        puts "  #{issue['key']} - #{issue['fields']['summary']}"
      end
    end
  end
end
