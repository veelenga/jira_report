Jira report
===========================

Generates a productivity report. Example of report see below.

##Installation:
```
gem install jira-report
```

##Usage:
```sh
$jira-report -h
Usage: jira-report [options]
    -u, --username username          Username to query statistic
    -s, --settings ini               Path to init file. .jira-report is default
```

Output example:
```
$jira-report -u admin
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

##Configuration:
Example of configuration file `.jira-report`:
```ini
[jira]
username=username
password=s3cr3t
url=jira.company.com
```
