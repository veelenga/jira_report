require 'rest_client'
require 'json'
require 'uri'

module JiraReport
  # With this class you can easily query user activities from jira
  # in specified period of time.
  #
  # ==== Examples
  #
  #   reporter = Reporter.new('jira.company.url', 'admin', 's3cr3t')
  #
  #   # returns all created issues by 'my_jira_name'
  #   all_created = reporter.created('my_jira_name')
  #
  #   # returns closed issues by 'admin' last week
  #   weekly_closed = reporter.closed('admin', '-1w')
  #
  #   # returns reopened issues by 'usr' in period starting
  #   # from two weeks ago and ending one week ago.
  #   reopened = reporter.reopened('usr', '-2w', '-1w')
  class Reporter
    REST_API_SEARCH_URL = 'rest/api/2/search?'

    # Initializes reporter.
    #
    # ==== Attributes
    #
    # * +site+ - jira site address.
    # * +usr+ - jira username.
    # * +pass+ - jira password.
    def initialize(site, usr, pass)
      fail 'url can\'t be nil' unless site
      fail 'usr can\'t be nil' unless usr
      fail 'pass can\'t be nil' unless pass

      @search_url = jira_api_url(site, usr, pass);
    end

    # Queries created issues by usr in specified period.
    #
    # ==== Attributes
    #
    # * +usr+ - username query statistic about.
    # * +from+ - period of time starts with this value (jql format).
    # * +till+ - period of time ends with this value (jql format).
    def created(usr, from=nil, till=nil)
      query_issues(jql_created usr, from, till)
    end

    # Queries resolved issues by usr in specified period.
    #
    # ==== Attributes
    #
    # * +usr+ - username query statistic about.
    # * +from+ - period of time starts with this value (jql format).
    # * +till+ - period of time ends with this value (jql format).
    def resolved(usr, from=nil, till=nil)
      query_issues(jql_resolved usr, from, till)
    end

    # Queries reopened issues by usr in specified period.
    #
    # ==== Attributes
    #
    # * +usr+ - username query statistic about.
    # * +from+ - period of time starts with this value (jql format).
    # * +till+ - period of time ends with this value (jql format).
    def reopened(usr, from=nil, till=nil)
      query_issues(jql_reopened usr, from, till)
    end

    # Queries closed issues by usr in specified period.
    #
    # ==== Attributes
    #
    # * +usr+ - username query statistic about.
    # * +from+ - period of time starts with this value (jql format).
    # * +till+ - period of time ends with this value (jql format).
    def closed(usr, from=nil, till=nil)
      query_issues(jql_closed usr, from, till)
    end

    # Queries issues using jql query.
    #
    # ==== Attributes
    #
    # * +jql+ - query in jira query languages.
    def query_issues(jql)
      response = RestClient.get(@search_url + URI.escape(jql))
      unless response.code == 200
        fail "Response code: #{response.code}"
      end
      JSON.parse(response.body)['issues']
    end

    private

    # Returns jira full rest api search url
    def jira_api_url(site, username, password)
      url = format_url(site, username, password)
      "#{url}/#{REST_API_SEARCH_URL}"
    end

    # Formats url in the following format:
    #  scheme://username:password@site
    #
    # If `site` parameter does not define scheme `http` will be used.
    def format_url(site, username, password)
      s = site.dup
      if !s.start_with? 'http'
        s = "http://#{s}"
      end

      u = URI.parse(s)

      <<-EOU.gsub(/\s+/, '').strip
        #{u.scheme + '://' if u.scheme}
        #{username}:#{password}@
        #{u.host}:#{u.port}#{u.path}
      EOU
    end

    # Prepares jql query based on parameters to
    # search created issues.
    def jql_created(usr, from, till)
      jql = 'jql='
      jql << "created>=#{from} AND " if from
      jql << "created<=#{till} AND " if till
      jql << "reporter=#{usr}"
    end

    # Prepares jql query based on parameters to
    # search resolved issues.
    def jql_resolved(usr, from, till)
      jql = 'jql='
      jql << "resolved>=#{from} AND " if from
      jql << "resolved<=#{till} AND " if till
      jql << "'First Resolution User'=#{usr}"
    end

    # Prepares jql query based on parameters to
    # search reopened issues.
    def jql_reopened(usr, from, till)
      jql = 'jql='
      jql << "'First Reopened Date'>=#{from} AND " if from
      jql << "'First Reopened Date'<=#{till} AND " if till
      jql << "'First Reopened User'=#{usr}"
    end

    # Prepares jql query based on parameters to
    # search closed issues.
    def jql_closed(usr, from, till)
      jql = 'jql='
      jql << "'First Closed Date'>=#{from} AND " if from
      jql << "'First Closed Date'<=#{till} AND " if till
      jql << "'First Closed User'=#{usr}"
    end
  end
end
