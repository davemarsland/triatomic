module.exports = (robot) ->

  robot.respond /what rooms are available\?/i, (msg) ->
    apiKey = 'AIzaSyBd3y9MQ3Ar-Dvf5dWpiM589YAWciS5KVI'
    url = "https://www.googleapis.com/calendar/v3/freeBusy?key=#{ apiKey }"
    d = new Date()
    now = d.toISOString()
    endOfDay = "#{ now.substr(0, 11) }23:59:59#{ now.substr(19) }"

    roomCalendars = ["just-eat.com_343436363431312d373030@resource.calendar.google.com"]

    post_data = JSON.stringify({
      'timeMin': now
      'timeMax': endOfDay
      items: roomCalendars
    })

    msg.send post_data

    msg.http(url)
      .post(post_data) (err, res, body) ->
          if err or res.statusCode isnt 200
              msg.send 'I\'ve encountered an error trying to get an available room. Sorry!'
              msg.send body
              return