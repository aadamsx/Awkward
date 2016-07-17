child_process = require 'child_process'
exec = child_process.exec
getStructured = require './structure'

run = (command,cb)->
  cp = exec(command, (e,r,b)->
    if e
      awkward.log chalk.red e
      return
    )
  cp.stdout.on('data', (data)->
    cb data
    )

mode_shell = (command)->
  run command, (data)->
    awkward.log ''
    awkward.log data

mode_js = (command, fn) ->
  run command, (data)->
    structured_op = getStructured data
    fn = fn.replace 'console.log', 'awkward.log'
    eval 'structured_op.'+fn


module.exports = (command) ->
  if command.indexOf('().') > -1
    mode_js command.split('().')[0], command.split('().')[1]
  else
    mode_shell command