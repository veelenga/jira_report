require 'rest_client'
require 'json'
require 'uri'

module JiraReport
  class Reporter
    def initialize(url, usr, pass)
      @search_url = jira_api_url(url, usr, pass);
    end

    def created(usr, from=nil, till=nil)
      query_issues(jql_created usr, from, till)
    end

    def resolved(usr, from=nil, till=nil)
      query_issues(jql_resolved usr, from, till)
    end

    def reopened(usr, from=nil, till=nil)
      query_issues(jql_reopened usr, from, till)
    end

    def closed(usr, from=nil, till=nil)
      query_issues(jql_closed usr, from, till)
    end

    def query_issues(jql)
      response = RestClient.get(@search_url + URI.escape(jql))
      unless response.code == 200
        fail "Got wrong response code: #{response.code}"
      end
      JSON.parse(response.body)['issues']
    end

    private

    # Returns jira rest api search url.
    def jira_api_url(url, username, password)
      "http://#{username}:#{password}@#{url}/rest/api/2/search?"
    end

    # Prepares jql query based on parameters to
    # search created issues.
    def jql_created(usr, from, till)
      jql = 'jql='
      jql << "created>=#{from} AND " if from
      jql << "created<=#{till} AND " if till
      jql << "reporter=#{username}"
    end

    # Prepares jql query based on parameters to
    # search resolved issues.
    def jql_resolved(usr, from, till)
      jql = 'jql='
      jql << "resolved>=#{from} AND " if from
      jql << "resolved<=#{till} AND " if till
      jql << "'First Resolution User'=#{username}"
    end

    # Prepares jql query based on parameters to
    # search reopened issues.
    def jql_reopened(usr, from, till)
      jql = 'jql='
      jql << "'First Reopened Date'>=#{from} AND " if from
      jql << "'First Reopened Date'<=#{till} AND " if till
      jql << "'First Reopened User'=#{username}"
    end

    # Prepares jql query based on parameters to
    # search closed issues.
    def jql_closed(usr, from, till)
      jql = 'jql='
      jql << "'First Closed Date'>=#{from} AND " if from
      jql << "'First Closed Date'<=#{till} AND " if till
      jql << "'First Closed User'=#{username}"
    end
  end
end
