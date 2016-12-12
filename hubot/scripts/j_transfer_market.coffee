cheerio = require 'cheerio'
phantom = require 'phantom'

module.exports = (robot) ->
  robot.hear /J (http.*)/i, (msg) ->
    url = msg.match[1]
    phantom.create().then (ph) ->
      ph.createPage().then (page) ->
        page.open(url).then (status) ->
          page.evaluate( -> document.querySelector('html').innerHTML).then (html) ->
            $ = cheerio.load html
            teams = []

            msg.send '<div id="trans">'

            $(".field").each (index, content) ->
              $team_name = $(".ttl-thin > span", content)
# output team name
              msg.send '<h4 class="teamName"><span>' + $team_name.text() + '</span></h4>'
              msg.send '<h5>IN</h5><table><thead><tr class="in"><th class="col02">選手名</th><th class="col02">前所属</th></tr></thead>'
              msg.send '<tbody>'
# output in list 
              $in = $(".list > ul", content).eq(0)
              $in_list = $('ul > li', $in)
              $in_list.each (index, content) ->
                before_team = $(".name > p", content).text().replace("［","").replace(" ］","").replace("←","").replace(" ","")
                name = $(".name > b", content).text()
                if index % 2 == 0
                  msg.send '<tr><td>' + name + '</td><td>' + before_team + '</td></tr>'
                else
                  msg.send '<tr class="nrow"><td>' + name + '</td><td>' + before_team + '</td></tr>'
              msg.send '</tbody></table>'

              msg.send '<h5>OUT</h5><table><thead><tr class="out"><th class="col02">選手名</th><th class="col02">移籍先</th></tr></thead>'
              msg.send '<tbody>'
# output out list 
              $out = $(".list > ul", content).eq(1)
              $out_list = $('ul > li', $out)
              $out_list.each (index, content) ->
                after_team = $(".name > p", content).text().replace("［","").replace(" ］","").replace("→","").replace(" ","")
                name = $(".name > b", content).text()
                if index % 2 == 0
                  msg.send '<tr><td>' + name + '</td><td>' + after_team + '</td></tr>'
                else
                  msg.send '<tr class="nrow"><td>' + name + '</td><td>' + after_team + '</td></tr>'
              msg.send '</tbody></table>'

            msg.send '</div>'
            ph.exit()
            phantom.exit()
