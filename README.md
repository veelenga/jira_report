jira_report
===========================

Generates a productivity report(lists of created, resolved, reopened and closed issues) for specified user and period of time.

##Installation
```
$gem install jira-report
```

##Usage
```sh
$jira-report -h
Usage: jira-report [options]
    -u, --username username          Username to query activity report.
    -c, --config config              Path to config file. USER_HOME/.jira-report is default.
```

```
$jira-report -u admin
Querying jira...
Jira activity report for [admin]:

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
  TST-6943 - Remove redundant org.apache.log4j dependcy from common part
  TST-5862 - Unable to install NGinx on HP-UX with Java 6
  TST-5857 - Put back support for Jdk 1.6
  TST-5840 - NGinx fails to handle interaction initiated
  GSM-364 -  Migration of existing units
```

##Configuration
Default path to configuration file is `~/.jira-report`. All settings are optional and may be read from user input. See [sample](examples/jira-report.sample).

Period is set by two options `period_from` and `period_till`. Both options support [advanced jira searching](https://confluence.atlassian.com/display/JIRA/Advanced+Searching) and accept dates, jira functions, aliasing. For example:

```
period_from=-3w
period_till=now()
```
