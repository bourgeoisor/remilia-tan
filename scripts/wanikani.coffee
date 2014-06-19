# Description:
#   Wanikani interactions for fun and gloating.
#
# Commands:
#   hubot wanikani reviews - Returns the calling user's review counts
#   hubot set my apikey to <key> - Sets the user's API key

http = require('http')

module.exports = (robot) ->

    robot.respond /wanikani reviews/i, (msg) ->
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
                             msg.send "Lessons: #{stats.lessons_available} - Reviews: #{stats.reviews_available} - Hour: #{stats.reviews_available_next_hour} - Day: #{stats.reviews_available_next_day}"
   
                         res.on 'error', (res) ->
                             msg.send "Error getting WK data: #{res.message}"
        req.end()
      else
        msg.send "No apikey found for #{user.name}"

    robot.respond /set my api\s?key to (\S+)/i, (msg) ->
      key = msg.match[1]
      user = robot.brain.userForId(msg.message.user.id)
      user.wanikani = user.wanikani or {}
      user.wanikani.apikey = key
      msg.send "Okay, #{msg.message.user.name}. I saved your key."
