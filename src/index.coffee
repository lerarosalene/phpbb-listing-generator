fs = require "node:fs/promises"
path = require "node:path"

EXT_REGEX = /\.[^\.]*$/g
EXT_MAPPING = {}

parseListing = (listing) ->
  listing
    .split '\n'
    .map (i) -> i.trim()
    .filter (i) -> i.length

formatFile = (file) ->
  contents = await fs.readFile file, "utf-8"
  ext = file.match EXT_REGEX
  ext = file unless ext
  tag = EXT_MAPPING[ext] or "CODE"
  return "[FIELDSET=\"#{file}\"][#{tag}]#{contents}[/#{tag}][/FIELDSET]"

main = ->
  [listingFile, resultFile] = process.argv.slice 2
  basedir = path.dirname path.resolve listingFile
  listing = await fs.readFile listingFile, "utf-8"
  files = parseListing listing
  chunks = await Promise.all files.map (file) -> formatFile(path.join(basedir, file))
  resultFile = "#{listingFile}.md" unless resultFile
  await fs.writeFile resultFile, chunks.join "\n\n"

main().catch (error) ->
  console.error error
  process.exit 1
