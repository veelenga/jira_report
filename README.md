#Jira Report [![Gem Version](https://badge.fury.io/rb/jira_report.svg)](https://rubygems.org/gems/jira_report) [![Build Status](https://api.travis-ci.org/veelenga/jira_report.svg)](https://travis-ci.org/veelenga/jira_report)

Queries user activities from jira for specified period of time and prints it to console.

##Installation
```
$ gem install jira_report
```

##Usage

Just run it. `jira-report` will ask you your jira location, who you are and what's your password:

```
$ jira-report
Jira site address: https://jira.company.com
Username for 'https://jira.company.com': admin
Password for 'https://jira.company.com':
Connecting to 'https://jira.company.com'. Pls wait...

What was [admin] doing:

Created: 2
  WFM-7180 - Provide static context for log property in BasicHashAnalyzer
  TST-5862 - Unable to install Nginx on HP-UX with Java 6

Resolved: 8
  GSM-364 - Migration of existing scenario
  WFM-5865 - NullPointerException while finding categories
  TST-5864 - Some NGinx installation improvements
  TST-5863 - NGinx minimal dependency
  SDK-7139 - Move common interfaces and classes from into individual jar
  SDK-7138 - Move common interfaces and classes from into individual dll
  TST-7111 - Event.getDonotNotify doesn't indicate about agent's state
  TST-6985 - TST classes should have static Log fields

Reopened: 0

Closed: 5
  TST-6943 - Remove redundant org.apache.log4j dependency from common part
  TST-5862 - Unable to install NGinx on HP-UX with Java 6
  TST-5857 - Put back support for Jdk 1.6
  TST-5840 - NGinx fails to handle interaction initiated
  GSM-364 -  Migration of existing units
```

`url`, `username`, `password` and some other parameters can be added to [configuration file](#configuration). Also you can use mixed approach (keep some options in file, others enter from command line). For example if you do not want to keep password in configuration file, just don't, you will be asked.

Also you can use it directly in ruby:

```ruby
require 'jira_report'

def print_issues(issues)
  issues.each do |issue|
    puts "  #{issue['key']} - #{issue['fields']['summary']}"
  end
end

reporter = JiraReport::Reporter.new('jira.company.com', 'admin', 's3cr3t')
# returns all created issues by 'my_jira_name'
all_created = reporter.created('my_jira_name')

# returns closed issues by 'admin' last week
weekly_closed = reporter.closed('admin', '-1w')

# returns reopened issues by 'usr' in period starting
# from two weeks ago and ending one week ago.
reopened = reporter.reopened('usr', '-2w', '-1w')

print_issues(weekly_closed)
```

##Configuration
Path to configuration file can be specified by `-c` command line argument. `~/.jira-report` is default.

There are three main options in config file to query jira:

```
url=jira.company.com
username=username
password=s3cr3t
```

all those are optional and if not specified user will be asked to enter it from command line.

Period is set by two options `period_from` and `period_till`. Both options support [advanced jira searching](https://confluence.atlassian.com/display/JIRA/Advanced+Searching) and accept dates, jira functions, aliasing. For example:

```
period_from=-1w
period_till=now()
```

If those options not specified in configuration file, last week activities will be queried (just as in example above).

You can look at configuration file [sample](example/jira-report.sample) in repository.
