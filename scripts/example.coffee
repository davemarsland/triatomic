module.exports = (robot) ->
robot.respond /ar|what (room|rooms) (is|are) available\?|available (rooms|room)\?/i, (msg) ->
apiKey = 'AIzaSyBd3y9MQ3Ar-Dvf5dWpiM589YAWciS5KVI'
url = "https://www.googleapis.com/calendar/v3/freeBusy?key=#{ apiKey }"
d = new Date()
now = d.toISOString()
endOfDay = "#{ now.substr(0, 11) }23:59:59#{ now.substr(19) }"

roomCalendars = []

for alias, room of rooms
  roomCalendars.push room.id

post_data = JSON.stringify({
  'timeMin': now
  'timeMax': endOfDay
  items: roomCalendars
})

robot.http(url)
  .post(post_data) (err, res, body) ->
      if err or res.statusCode isnt 200
          msg.send 'I\'ve encountered an error trying to get an available room. Sorry!'
          return
        msg.send 'Here'