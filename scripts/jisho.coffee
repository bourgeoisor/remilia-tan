# Description:
#   Searches jisho for a given word or sentence
#
# Commands:
#   hubot jisho me <phrase> - Searches for a translation for the <phrase> on jisho.

cheerio = require 'cheerio'

module.exports = (robot) ->
  robot.respond /jisho( me)? (.*)/i, (msg) ->
    robot.http("http://beta.jisho.org/search/#{msg.match[2]}")
      .get() (err, res, body) ->
        out = []
        $ = cheerio.load(body)
        $('.concept_light.clearfix').map (i, el) ->
          if i > 2 then return false
          kanji = $(this).find('span[class=text]')?.first()?.text().trim()
          out.push "#{kanji}"
          meaning = []
          $(this).find('.meaning-wrapper.row').each (i, el) ->
            pos = $(this).prev('.meaning-tags.row')?.text().trim()
            if pos != "Notes" && pos != "Other forms"
              if pos != "" then meaning.push "[#{pos}]"
              meaning.push "#{i+1}. #{$(this).find('span[class=meaning-meaning]').text().trim()}"
          out.push meaning.join(' ')
        if out.length == 0
          msg.send "Sorry, couldn't find anything matching #{msg.match[2]}"
        else
          msg.send out.join('\n')
