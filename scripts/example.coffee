# Description:
#   Get google calendar information from Hubot
#
# Dependencies:
#   "coffee-script": "~1.6",
#   "moment": "~2.9.0",
#   "moment-timezone": "~0.3.0"
#   "hubot-googleapis": "~0.2.0"
#
# Configuration:
#   GOOGLE_API_CLIENT_ID      # hubot-googleapi
#   GOOGLE_API_CLIENT_SECRET  # hubot-googleapi
#   GOOGLE_API_SCOPES         # hubot-googleapi
#
# Commands:
#   hubot gcal me - "Retrieves the events for the immediate future (defaults to a day)."
#   hubot gcal calendar some.calendar@example.com - "Sets the calendar for the current user."
#   hubot gcal look 10 days ahead - "Calls to `gcal me` will return 10 days worth of events."
#   hubot gcal timezone America/Phoenix - "Sets the timezone for the current user."
#
# Author:
#   hubot-me

# TODO: robot.respond /gcal auto/ # enable/disable auto away behavior
# TODO: robot.respond /gcal whereabouts/ # where is everyone
# TODO: for recurring, make sure I'm showing the next occurrence, and all after that
# TODO: set the cron interval for auto-away status updates
# TODO: discard events not in the future

module.exports = (robot) ->

  moment = require('moment')
  require('moment-timezone')

  userId = "dave.marsland@just-eat.com"
  FPHmeetingrooms = ["just-eat.com_2d373139323835392d373237@resource.calendar.google.com", "just-eat.com_3937353431303039313731@resource.calendar.google.com","just-eat.com_34363032303933312d393832@resource.calendar.google.com"]

  robot.respond /set calendar (.*)/i, (msg)->
    userId = msg.match[1]
    msg.reply "OK, set your calendar to #{userId}"

  # return the calendar events for the immediate future
  robot.respond /do I have any meetings in the next (.*) hours/i, (msg)->
    now = moment().toISOString()
    hoursAhead = msg.match[1]
    meetings = 0
    in24 = moment().add(hoursAhead,'hours').toISOString()
    robot.emit "googleapi:request",
      service: "calendar"
      version: "v3"
      endpoint: "events.list"
      params:
        timeMin: now
        timeMax: in24
        singleEvents: true
        calendarId: userId
      callback: (err, data)->
        return msg.reply err if err
        message = ""
        timeZone = 'Europe/London'
        meetings = data.items.length
        items = data.items
        console.log items
        message += if items.length > 0
                     "In the next #{hoursAhead} hour(s): #{meetings} meetings"
                   else
                     "Nope, you are free, go to the pub."
        msg.send message

  # return the calendar events for the immediate future
  robot.respond /what meetings do I have in the next (.*) hours/i, (msg)->
    now = moment().toISOString()
    hoursAhead = msg.match[1]
    meetings = 0
    in24 = moment().add(hoursAhead,'hours').toISOString()
    robot.emit "googleapi:request",
      service: "calendar"
      version: "v3"
      endpoint: "events.list"
      params:
        timeMin: now
        timeMax: in24
        singleEvents: true
        calendarId: userId
      callback: (err, data)->
        return msg.reply err if err
        message = ""
        timeZone = 'Europe/London'
        meetings = data.items.length
        items = data.items.map((item)->
          if item.start.date
            start = item.start.date
            end = item.end.date
            format = 'M/D'
          else
            start = item.start.dateTime
            end = item.end.dateTime
            format = 'M/D h:mm'

          start = moment(start)
          start = start.tz(timeZone || item.start.timeZone || 'Europe/London')

          end = moment(end)
          end = end.tz(timeZone || item.end.timeZone || 'Europe/London')

          entry =  "[#{start.format(format)}-#{end.format(format)}]  #{item.summary}\n"
          # entry += "[#{start.toString()}-#{end.toString()}]\n"
          entry += "(#{item.location})\n" if item.location
          entry += "event   => #{item.htmlLink}\n"
          entry += "hangout => #{item.hangoutLink}\n" if item.hangoutLink

          entry
        ).join("\n")
        console.log items
        message += if items.length > 0
                     "Meetings in the next #{hoursAhead} hour(s): #{items}"
                   else
                     "Nope, you are free, go to the pub."
        msg.send message

  # return the calendar events for the immediate future
  robot.respond /do Which meeting rooms are free/i, (msg)->
    now = moment().toISOString()
    in30 = moment().add(30,'minutes').toISOString()
    freerooms = ""
    for room in FPHmeetingrooms
      msg.send room
      robot.emit "googleapi:request",
        service: "calendar"
        version: "v3"
        endpoint: "events.list"
        params:
          timeMin: now
          timeMax: in30
          singleEvents: true
          calendarId: room
        callback: (err, data)->
          return msg.reply err if err
          timeZone = 'Europe/London'
          console.log room + " " + data
          items = data.items
          msg.send items.length.toString()
          if (typeof items == "undefined" || items == null) || items.length.toString() == "0"
            msg.send room
            freerooms += room
    
    if freerooms.length == 0
      msg.send "No rooms..."  
    else
      msg.send freerooms + ", go go go"