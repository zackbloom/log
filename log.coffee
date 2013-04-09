return unless window.console and window.console.log

log = ->
    args = []

    makeArray(arguments).forEach (arg) ->
        if typeof arg is 'string'
            args = stringToArgs arg

        else
            args.push arg

    _log.apply window, args

_log = ->
    if window.console and window.console.log
        console.log.apply console, makeArray(arguments)

makeArray = (arrayLikeThing) ->
    Array::slice.call arrayLikeThing

stringToArgs = (str, args) ->
    styles = []

    if /\*(.+)*/.test str
        str = str.replace(/(.+)?\*(.+)\*(.+)?/, '$1%c$2%c$3')
        styles = styles.concat ['font-weight: bold', '']

    if /\_(.+)_/.test str
        str = str.replace(/(.+)?\_(.+)\_(.+)?/, '$1%c$2%c$3')
        styles = styles.concat ['font-style: italic', '']

    [str].concat styles

# Export
window.log = log
window.log.l = _log