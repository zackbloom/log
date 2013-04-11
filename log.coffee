getMarkdownInstance = ->
  new markdown.Markdown(markdown.Markdown.dialects.Gruber)

parse = (input) ->
  md = getMarkdownInstance()

  md.processInline input

isArray = (obj) ->
  obj.constructor.toString().indexOf('Array') != -1

append = (arr1, arr2) ->
  arr1.splice arr1.length, 0, arr2...
  arr1

merge = (obj1, obj2) ->
  for k, v of obj2
    obj1[k] = v
  obj1

applyToken = (token) ->
  element = null
  format = null

  addFormat = (obj) ->
    format ?= {}
    merge format, obj

  if not isArray token
    # It's just text
    element = token
  else
    # It's a tag (possibly with more tags nested in the block)
    [type, block] = token

    switch type
      when 'inlinecode'
        addFormat
          'font-family': 'monospace'

      when 'em'
        addFormat
          'font-weight': 900

    block = applyToken block

    element = block.element
    merge format, block.format

  return {element, format}

buildCSS = (format) ->
  out = ''
  for key, val of format
    out += "#{ key }: #{ val };"
  out

emit = (tokens) ->
  # We keep them seperate for clarity, but the message which goes to the logger
  # is just the formatters appended to the end of the elements.
  elements = []
  formatters = []

  # %c's are used to style succeding blocks of text.
  #
  # The next %c resets the styles.  If there are two styled blocks 
  # one after another there is no problem as the second's styles will
  # reset the first, but if there is a nonstyled block after a styled
  # we need an extra %c to clear the previous styles.
  inStyle = false

  for token in tokens
    {element, format} = applyToken token

    if format
      elements.push '%c'
      formatters.push buildCSS format
      inStyle = true

    else if inStyle
      elements.push '%c'
      formatters.push ''
      inStyle = false

    elements.push element

  {elements, formatters}

log = (messages...) ->
  logFormats = []
  logElements = []

  for message in messages
    tokens = parse message
    {elements, formatters} = emit tokens

    logElements.push elements.join('')
    append logFormats, formatters

  logArgs = [logElements.join(' ')]
  append logArgs, logFormats

  console.log logArgs...

window.log = log
