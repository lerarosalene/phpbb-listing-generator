fs = require "node:fs/promises"
path = require "node:path"

EXT_REGEX = /\.[^\.]*$/g
BRACKET = "["

parseListing = (listing) ->
  listing
    .split '\n'
    .map (i) -> i.trim()
    .filter (i) -> i.length

formatFile = (file, extMapping, basedir) ->
  contents = await fs.readFile file, "utf-8"
  ext = file.match EXT_REGEX
  ext = file unless ext
  tag = extMapping[ext] or "CODE"
  return "#{BRACKET}FIELDSET=\"#{path.relative(basedir, file)}\"]" +
         "[#{tag}]#{contents}[/#{tag}]#{BRACKET}/FIELDSET]"

generateExtMapping = (tags = "") ->
  result = {}
  for tagDescriptor from tags.split ","
    [ext, tag] = tagDescriptor.split('=')
    continue unless tag
    result[ext] = tag
  return result

usage = () ->
  console.log "bb-listing <infile> <outfile> [tag descriptors]"
  console.log "  tag descriptor defines extension to BB code correspondance"
  console.log "  for example: bb-listing listing.txt listing.md \".js=JS,.html=HTML\""
  console.log "  extensions not found in this mapping will use #{BRACKET}CODE] as fallback"
  console.log "  if file has no extension, it's name is considered extension as" +
              " a whole (without leading dot)"

main = ->
  [listingFile, resultFile, tags] = process.argv.slice 2
  return usage() unless resultFile
  basedir = path.dirname path.resolve listingFile
  listing = await fs.readFile listingFile, "utf-8"
  files = parseListing listing
  extMapping = generateExtMapping tags
  chunks =
    await Promise.all files.map (file) ->
      formatFile(path.join(basedir, file), extMapping, basedir)
  await fs.writeFile resultFile, chunks.join "\n\n"

main().catch (error) ->
  console.error error
  process.exit 1
