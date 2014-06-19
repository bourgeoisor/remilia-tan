# Description:
#   Wanikani interactions for fun and gloating.
#
# Commands:
#   hubot set my wanikani api key to <key> - Sets the user's API key
#   hubot what is my review count - Returns the calling user's review counts
#   hubot wanikani status - Returns the status of the user's items

http = require('http')

module.exports = (robot) ->

    robot.respond /set my wanikani api\s?key to (\S+)/i, (msg) ->
      key = msg.match[1]
      user = robot.brain.userForId(msg.message.user.id)
      user.wanikani = user.wanikani or {}
      user.wanikani.apikey = key
      msg.send "Okay, #{msg.message.user.name}. I saved your key."
      
    robot.respond /what is my review count/i, (msg) ->
      user = robot.brain.userForId(msg.message.user.id)
      apikey = user.wanikani?.apikey

      if apikey
        req = http.get {hostname: "www.wanikani.com", path:"/api/user/#{apikey}/study-queue/"}, 
        	       (res) -> 
                         data = ''
                         res.on 'data', (chunk) ->
                             data += chunk

                         res.on 'end', () ->
                             stats = JSON.parse data
                             if stats.error
                               msg.send "Error: #{stats.error.message}"
                               return

                             stats = stats.requested_information
                             msg.send "Lessons: #{stats.lessons_available} - Reviews: #{stats.reviews_available} - Next Hour: #{stats.reviews_available_next_hour} - Next Day: #{stats.reviews_available_next_day}"

                         res.on 'error', (res) ->
                             msg.send "Error getting WK data: #{res.message}"
        req.end()
      else
        msg.send "No apikey found for #{user.name}"

    robot.respond /wanikani status/i, (msg) ->
      user = robot.brain.userForId(msg.message.user.id)
      apikey = user.wanikani?.apikey
      
      if apikey
        req = http.get {hostname: "www.wanikani.com", path:"/api/user/#{apikey}/srs-distribution/"},
          (res) ->
            data = ''
            res.on 'data', (chunk) ->
                     data += chunk
            res.on 'error', (res) ->
                     msg.send "Error getting WK data: #{res.message}"
            res.on 'end', () ->
              stats = JSON.parse data
              if stats.error
                msg.send "Error: #{stats.error.message}"
                return

              stats = stats.requested_information
              msg.send "Apprentice: #{stats.apprentice?.total} - Guru: #{stats.guru?.total} - Master: #{stats.master?.total} - Enlightend: #{stats.enlighten?.total} - Burned: #{stats.burned?.total}"
      else
        msg.send "No apikey found for #{user.name}."
          
