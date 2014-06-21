# Description:
# Interacts with Last.fm.
#
# Commands:
# hubot I'm <username> on lastfm - Sets your Last.fm username.
# hubot np - Displays what you're currently scrobbling.
# hubot what am I listening to? - Displays what you're currently scrobbling.
# hubot what's <name> listening to? - Displays what someone's currently scrobbling.

LastFm = require('lastfm').LastFmNode

module.exports = (robot) ->

  robot.respond /I'm (\w+) on last\.?fm/i, (msg) ->
    username = msg.match[1]

    user = robot.brain.userForId(msg.message.user.id)
    user.lastfm = user.lastfm or {}
    user.lastfm.username = username

    msg.send "Okay, you're #{username} on Last.fm!"

  robot.respond /(?:what's (.*)|what am I) listening to|np/i, (msg) ->
    name = msg.match[1] || msg.message.user.name

    users = robot.brain.usersForFuzzyName(name)

    if users.length is 1
      nowPlayingForUser users[0], msg
    else if users.length > 1
      msg.send "Be more specific, I know #{users.length} people named like that: " +
      (user.name for user in users).join(', ')
    else
      msg.send "#{name}? Never heard of 'em!"

nowPlayingForLastfmUser = (username, callbacks) ->
  lastfm = new LastFm
    api_key: process.env.HUBOT_LASTFM_API_KEY
    secret: process.env.HUBOT_LASTFM_API_SECRET
    useragent: 'hubot/v1.0 LevelUp Hubot'

  lastfm.request 'user.getRecentTracks',
    user: username
    limit: 1
    handlers:
      success: (data) ->
        track = data?.recenttracks?.track?[0]

        if track?['@attr']?.nowplaying is 'true'
          callbacks.success
            artist: track.artist['#text']
            title: track.name
        else
          callbacks.success null

      error: callbacks.error

nowPlayingForUser = (user, msg) ->
  if user.lastfm?.username?
    nowPlayingForLastfmUser user.lastfm.username,
      success: (track) ->
        if track
          msg.send "#{user.name} is listening to #{track.title} by #{track.artist}"
        else
          msg.send "#{user.name} is not scrobbling anything!"
      error: (error) ->
        msg.send "Oh no! An error occurred: #{error.message}"
  else
    msg.send "I don't know #{user.name}'s Last.fm username!"

