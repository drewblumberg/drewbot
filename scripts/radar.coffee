# Script to generate radar gif
yaml = require('js-yaml');
fs   = require('fs');

set_location = (location, msg, robot) ->
  user = msg.message.user.name
  nick = user.split(" ")[0]
  robot.brain.data[user + "-location"] = location
  return "Okay " + nick + ". You live in " + location

get_radar = (msg, robot) -> 
  user = msg.message.user.name
  nick = msg.message.user.name.split(" ")[0]

  if msg.match[1].match(/me/)
    loc = robot.brain.data[user + "-location"]
    if loc == ""
      msg.send "Sorry " + nick + ", I don't know where you live."
    location = loc.split(',')[1].trim() + '/' + loc.split(',')[0].trim()
  else if msg.match[1].match(/(^\d{5}$)|(^\d{5}-\d{4}$)/)
    location = msg.match[1]
  else
    msg.send "Sorry " + nick + ", I can't get a radar image for you."

  file = fs.readFileSync('/Users/drewblumberg/code/drewbot/keys.yml', 'utf8')
  api_key = yaml.safeLoad(file).wunderground.key
  url = "http://api.wunderground.com/api/"
  url += api_key
  url += "/animatedradar/q/"
  url += location
  url += ".gif?newmaps=1&timelabel=1&timelabel.y=10&num=5&delay=50"

  msg.reply url

module.exports = (robot) ->
  robot.respond /i live (at|in) (.*)$/i, (msg) ->
    msg.send set_location msg.match[2].trim(), msg, robot

  robot.hear /radar (.*)/i, (msg) ->
    get_radar msg, robot
