#!/usr/bin/env ruby

require 'slack-ruby-client'
require 'date'
require 'pry'

# Send message to all of these channels
# If your channel is private, you need to lookup the ID
channels_data = [
  { 
    "channel_name" => "standups", 
    "channel_id" => "", 
    "token" => ENV['SLACK_API_TOKEN']
  }
]

# Send a direct message
def send_dm(client, user_name, message)
  user = client.users_info(user: "@" + user_name.to_s)
  conversation = client.conversations_open(users: user.user.id)
  client.chat_postMessage(channel: conversation.channel.id, text: message, as_user: true)
end

# Get channel id by name (Only if the channel is public)
def get_channel_by_name(client, channel_name)
  channel_data = client.channels_info(channel: "#" + channel_name.to_s)
  channel_data.channel.id
end

# Send the message to the channel
# Customize your message here.
def send_message_to_channel(client, channel_id, title, message)
  client.chat_postMessage(
    channel: channel_id, 
    as_user: true,
    text: "*" + title + "*",
    attachments: [
      text: message,
      color: "warning"
    ]
  )
end

# Get your report data from a file. Customize this for your own needs.
def get_report()
  # Get yesterday unless today is Monday then get Friday
  today = Date.today.strftime('%m/%d/%Y')
  yesterday = (Date.today-(Date.today.monday? ? 3 : 1)).strftime('%m/%d/%Y')
  date_pattern = /\d\d\/\d\d\/\d\d\d\d/
  report = ""
  last_date = ""
  File.foreach("$HOME/standup_report.txt") do |line|
    data = line.chomp
    last_date = data if date_pattern.match(data)
    next if last_date == today || (last_date == yesterday && date_pattern.match(data))

    # End of 'yesterdays' report
    break if last_date != yesterday && date_pattern.match(data)

    report += data + "\n"
  end
  report
end

# Send message/report to all specified slack channels and groups
def send_to_slack(token, channel_id, report_data)   
  Slack.configure do |config|
      config.token = token
  end

  client = Slack::Web::Client.new
  client.auth_test

  message_title = "Standup Report"

  send_message_to_channel(client, channel_id, message_title, report_data)
end

report_data = get_report()
channels_data.each do |data|
  # If you are using channel names and not just channel ids, do the channel name lookup.
  send_to_slack(data["token"], data["channel_id"], report_data)   
end

