cheerio = require 'cheerio'
phantom = require 'phantom'

module.exports = (robot) ->
  robot.hear /BK (http.*)/i, (msg) ->
    url = msg.match[1]
    phantom.create().then (ph) ->
      ph.createPage().then (page) ->
        page.open(url).then (status) ->
          page.evaluate( -> document.querySelector('html').innerHTML).then (html) ->
            $ = cheerio.load html
            team1 =
              name: ""
              starting_lineup: []
              sub: []
            team2 =
              name: ""
              starting_lineup: []
              sub: []

            team1.name = $(".half_left h5").eq(0).text()
            $(".half_left tr").each (index, content) ->
              position = $("th", content)
              player = $("td", content)
              formatted_player =
                order: position.eq(0).text()
                position: position.eq(1).text()
                name: player.eq(0).text()
              team1.starting_lineup.push formatted_player

            team2.name = $(".half_right h5").eq(0).text()
            $(".half_right tr").each (index, content) ->
              position = $("th", content)
              player = $("td", content)
              formatted_player =
                order: position.eq(0).text()
                position: position.eq(1).text()
                name: player.eq(0).text()
              team2.starting_lineup.push formatted_player

            place = $(".place").text()

            title = "【スタメン】" + team1.name + "－" + team2.name + "（" + place + "／◯時）" + "\n"
            team_order_1 = ""
            for player in team1.starting_lineup
              position = player.position
              if position == "DH"
                position = "指"
              team_order_1 += "（" + position + "）" + player.name + "\n"
            msg.send title + "◆ " + team1.name + "\n" + team_order_1

            team_order_2 = ""
            for player in team2.starting_lineup
              position = player.position
              if position == "DH"
                position = "指"
              team_order_2 += "（" + position + "）" + player.name + "\n"
            msg.send title + "◆ " + team2.name + "\n" + team_order_2

            ph.exit()
            phantom.exit()
