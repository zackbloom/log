parseAndAddArgs = (str, args) ->
    if /\*(.+)*/.test str
        str.replace(/(.+)?\*(.+)\*(.+)?/, '$1%c$2%c$3')
        args.push 'font-weight: bold'
        args.push ''

    if /\_(.+)_/.test str
        str.replace(/(.+)?\_(.+)\_(.+)?/, '$1%c$2%c$3')
        args.push 'font-style: italic'
        args.push ''

_log = -> console.log.apply console, Array::slice.call(arguments) if @console and @console.log

window.log = ->
    finalArguments = []

    arguments.forEach (arg) ->
        if typeof arg is 'string'
            parseAndAddArgs arg, finalArguments

        else
            finalArguments.push arg

    _log.apply window, Array::slice.call(finalArguments)

window.log.literal = window.log.l = _log