# Description:
#   Shutdown the robot
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot shutdown
#

module.exports = (robot) ->
  robot.respond /shutdown/i, (msg) ->
    msg.send "I'll be back"
    robot.shutdown()
    process.exit()

