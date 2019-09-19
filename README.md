# Standup Report

Automate posting a message to a Slack channel from a document you contribute to throughout the day. 

I am using a Slack legacy token to avoid using a Slack app. The number of Slack apps are limited and this script is designed to only be used by me and not the whole team.

## Requirements

I run this script on my Macbook Pro running Mojave.

**Slack Legacy API Token**

Sign into your Slack groups in a browser. Go to the following URL to create legacy tokens for each one.

[https://api.slack.com/custom-integrations/legacy-tokens](https://api.slack.com/custom-integrations/legacy-tokens)

**Ruby**

**Cron**

## Installation and Setup

**Ruby**

I use [rbenv](https://github.com/rbenv/rbenv) to manage my Ruby versions. This made using cron a little difficult but I got it to work.

Gem [Slack Web Client](https://github.com/slack-ruby/slack-ruby-client)

**Cron Setup**

Edit your cron jobs:

```
crontab -e
```

Adding the following line will run the report script every weekday at 9:00 AM. 
Cron and rbenv did not play well together at first. I got cron to use the 
right version of Ruby with this line.

```
0 9 * * 1-5 /usr/local/bin/rbenv ruby /path/to/report.rb >> /tmp/standup.log 2>&1
```

**Data File**

I made a file with a very simple format for my report data. The script will 
ignore TODAY's date and post only the text between the date lines for 
yesterday. On Monday, the script will look for Friday's date. 

Example data file:

```
07/29/2019
This monday report will be posted on Tuesdsay.
07/26/2019
Happy friday! This report will be posted on Monday.
07/25/2019
Thought about writing tests but didn't write anything.
Wrote on two lines to show that both will be posted in my report.
07/24/2019
Changed a lot in the script.
07/23/2019
Created an automated standup report Slack script.
```

## To Dos

* Implement cron through [whenever](https://github.com/javan/whenever).
* Add random timer to make it look not so automated to your coworkers.
* Add random color strip for the message.
* Add data to a repo and pull the latest before running the script.

Some suggested differences for getting the data could be:

* Post the most recent data regardless of date.
* Post the whole contents of the report file and don't keep a history.
* Post the report then archive the file.
* Use multiple data files.


