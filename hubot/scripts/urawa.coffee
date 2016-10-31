cheerio = require 'cheerio'
phantom = require 'phantom'

module.exports = (robot) ->
  robot.hear /^(http.*)/i, (msg) ->
    url = msg.match[1]
    phantom.create().then (ph) ->
      ph.createPage().then (page) ->
        page.open(url).then (status) ->
          page.evaluate( -> document.querySelector('html').innerHTML).then (html) ->
            $ = cheerio.load html
            team1 =
              name: ""
              GK: ""
              DF: []
              MF: []
              FW: []
              sub:
                GK: []
                DF: []
                MF: []
                FW: []
            team2 =
              name: ""
              GK: ""
              DF: []
              MF: []
              FW: []
              sub:
                GK: []
                DF: []
                MF: []
                FW: []
            team1.name = $(".ListTop p span").eq(0).text()
            $("ul.dataList").eq(0).children().each (index, content) ->
              if index != 0
                position = $('.ListPosition', content).text()
                player_name = $('.ListName', content).text().replace("　", "")
                if position == 'GK'
                  team1.GK = player_name
                else if position == 'DF'
                  team1.DF.push player_name
                else if position == 'MF'
                  team1.MF.push player_name
                else if position == 'FW'
                  team1.FW.push player_name
            team2.name = $(".ListTop p span").eq(1).text()
            $("ul.dataList").eq(1).children().each (index, content) ->
              if index != 0
                position = $('.ListPosition', content).text()
                player_name = $('.ListName', content).text().replace("　", "")
                if position == 'GK'
                  team2.GK = player_name
                else if position == 'DF'
                  team2.DF.push player_name
                else if position == 'MF'
                  team2.MF.push player_name
                else if position == 'FW'
                  team2.FW.push player_name

            $("ul.dataList").eq(2).children().each (index, content) ->
              if index != 0
                position = $('.ListPosition', content).text()
                player_name = $('.ListName', content).text().replace("　", "")
                if position == 'GK'
                  team1.sub.GK.push player_name
                else if position == 'DF'
                  team1.sub.DF.push player_name
                else if position == 'MF'
                  team1.sub.MF.push player_name
                else if position == 'FW'
                  team1.sub.FW.push player_name

            $("ul.dataList").eq(3).children().each (index, content) ->
              if index != 0
                position = $('.ListPosition', content).text()
                player_name = $('.ListName', content).text().replace("　", "")
                if position == 'GK'
                  team2.sub.GK.push player_name
                else if position == 'DF'
                  team2.sub.DF.push player_name
                else if position == 'MF'
                  team2.sub.MF.push player_name
                else if position == 'FW'
                  team2.sub.FW.push player_name

            title = "【速報】" + team1.name + "vs" + team2.name + " 先発"
            team1_GK = "GK " + team1.GK
            team1_DF = "DF "
            for player_name in team1.DF
              team1_DF = team1_DF + player_name + " "
            team1_MF = "MF "
            for player_name in team1.MF
              team1_MF = team1_MF + player_name + " "
            team1_FW = "FW "
            for player_name in team1.FW
              team1_FW = team1_FW + player_name + " "
            team2_GK = "GK " + team2.GK
            team2_DF = "DF "
            for player_name in team2.DF
              team2_DF = team2_DF + player_name + " "
            team2_MF = "MF "
            for player_name in team2.MF
              team2_MF = team2_MF + player_name + " "
            team2_FW = "FW "
            for player_name in team2.FW
              team2_FW = team2_FW + player_name + " "

            team1_sub_GK = "GK "
            for player_name in team1.sub.GK
              team1_sub_GK = team1_sub_GK + player_name + " "
            team1_sub_DF = "DF "
            for player_name in team1.sub.DF
              team1_sub_DF = team1_sub_DF + player_name + " "
            team1_sub_MF = "MF "
            for player_name in team1.sub.MF
              team1_sub_MF = team1_sub_MF + player_name + " "
            team1_sub_FW = "FW "
            for player_name in team1.sub.FW
              team1_sub_FW = team1_sub_FW + player_name + " "

            team2_sub_GK = "GK "
            for player_name in team2.sub.GK
              team2_sub_GK = team2_sub_GK + player_name + " "
            team2_sub_DF = "DF "
            for player_name in team2.sub.DF
              team2_sub_DF = team2_sub_DF + player_name + " "
            team2_sub_MF = "MF "
            for player_name in team2.sub.MF
              team2_sub_MF = team2_sub_MF + player_name + " "
            team2_sub_FW = "FW "
            for player_name in team2.sub.FW
              team2_sub_FW = team2_sub_FW + player_name + " "

            msg.send title + "\n" + team1.name + "\n" + team1_GK + "\n" + team1_DF + "\n" + team1_MF + "\n" + team1_FW + "\n\nサブ\n" + team1_sub_GK + "\n" + team1_sub_DF + "\n" + team1_sub_MF + "\n" + team1_sub_FW + "\n\n" + team2.name + "\n" + team2_GK + "\n" + team2_DF + "\n" + team2_MF + "\n" + team2_FW  + "\n\nサブ\n" + team2_sub_GK + "\n" + team2_sub_DF + "\n" + team2_sub_MF + "\n" + team2_sub_FW + "\n\n"
            ph.exit()
            phantom.exit()
