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
        zenbar = $('section[id=zen_bar]')
        if zenbar.length == 1 
          zenbar.find('li[class=clearfix]').each (i, el) ->
            pos = $(this).attr("data-pos")
            if !(text = $(this).find('a').first().text())
              text = $(this).find('span[class=unlinked]').text()
            if pos 
              out.push "#{text} [#{pos}]"
            else
              out.push text
          msg.send out.join(', ')
        else
          $('.concept_light.clearfix').each (i, el) ->
            if i > 2 then return false
            kanji = $(this).find('span[class=text]').first().text().trim()
            out.push "#{kanji}"
            meaning = []
            $(this).find('.meaning-wrapper.row').each (i, el) ->
              pos = $(this).prev('.meaning-tags.row').text().trim()
              if pos != "Notes" && pos != "Other forms"
                if pos != "" then meaning.push "[#{pos}]"
                meaning.push "#{i+1}. #{$(this).find('span[class=meaning-meaning]').text().trim()}"
            out.push meaning.join(' ')
          if out.length == 0
            msg.send "Sorry, couldn't find anything matching #{msg.match[2]}"
          else
            msg.send out.join('\n')
