# Description:
#   Show version info
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot version
#

fs = require('fs')

module.exports = (robot) ->
  robot.respond /version/i, (msg) ->
    fs.readFile process.cwd() + '/VERSION', 'utf8', (err,data) ->
      if err
        msg.send "Sorry, no idea what version I am"
      else
        msg.send "I'm version " + data
