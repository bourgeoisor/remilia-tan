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
        out = ""
        $ = cheerio.load(body)
        $('.concept_light.clearfix').map (i, el) ->
          if i > 4 then return
          kanji = $(this).find('span[class=text]')?.first()?.text()
          out += "#{kanji}\n"
          $(this).find('.meaning-wrapper.row').each (i, el) ->
            pos = $(this).prev('.meaning-tags.row')?.text()
            if pos != "" then out += "  #{pos}\n"
            out += "    #{i+1}. #{$(this).find('span[class=meaning-meaning]').text()}\n"
        msg.send out
