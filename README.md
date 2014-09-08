Jira weekly report
===========================

Simple tools that generates jira weekly report. Report sample see below.

Usage:
```sh
$ruby weekly_report.rb -h
Usage: weekly_report.rb [options]
    -u, --username username          Username to get weekly jira statistic on
    -s, --settings path_to_settings  Specifies path to your settings file. Not mandatory. settings.ini used by
default

```

Output example:
```sh
$ruby weekly_report.rb -u admin
Querying jira...
Last week activities report in Jira for [admin]:

Created: 5
  WFM-7180 - Provide static context for log property in BasicHashAnalyzer 
  WFM-5865 - NullPointerException while finding categories
  TST-5864 - Some NGinx installation improvements
  TST-5863 - QA: NGinx minimal acceptance suite creation
  TST-5862 - Unable to install Nginx on HP-UX with Java 6

Resolved: 1
  GSM-364 - Migration of existing scenario

Reopened: 0

Closed: 9
  SDK-7139 - Move common interfaces and classes from into individual jar
  SDK-7138 - Move common interfaces and classes from into individual dll
  TST-7111 - Event.getDonotNotify doesn't indicate about agent's state
  TST-6985 - TST classes should have static Log fields
  TST-6943 - Remove redundant org.apache.log4j dependcy from common part
  TST-5862 - Unable to install NGinx on HP-UX with Java 6
  TST-5857 - Put back support for Jdk 1.6
  TST-5840 - NGinx fails to handle interaction initiated
  GSM-364 -  Migration of existing scenario
```

For initialization settings.ini file is required. Example of settings.ini
```ini
[jira]
username=username
password=s3cr3t
url=jira.company.com
```
