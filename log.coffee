return unless window.console and window.console.log

log = ->
    finalArguments = []

    args = Array::slice.call arguments

    args.forEach (arg) ->
        if typeof arg is 'string'
            parseAndAddArgs arg, finalArguments

        else
            finalArguments.push arg

    _log.apply window, Array::slice.call(finalArguments)

_log = ->
    if window.console and window.console.log
        console.log.apply console, Array::slice.call(arguments)

parseAndAddArgs = (str, args) ->
    argsToAdd = []

    if /\*(.+)*/.test str
        str = str.replace(/(.+)?\*(.+)\*(.+)?/, '$1%c$2%c$3')
        argsToAdd.push 'font-weight: bold'
        argsToAdd.push ''

    if /\_(.+)_/.test str
        str = str.replace(/(.+)?\_(.+)\_(.+)?/, '$1%c$2%c$3')
        argsToAdd.push 'font-style: italic'
        argsToAdd.push ''

    argsToAdd.unshift str
    argsToAdd.forEach (arg) -> args.push arg

# Export
window.log = log
window.log.l = _log