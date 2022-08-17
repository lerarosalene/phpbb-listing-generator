coffee = require "coffeescript"
fs = require "node:fs/promises"
path = require "node:path"

main = () ->
  src = await fs.readFile path.join("src", "index.coffee"), "utf-8"
  result = coffee.compile src
  await fs.mkdir "lib", { recursive: true }
  await fs.writeFile path.join("lib", "index.js"), "#!/usr/bin/env node\n\n#{result}"

main().catch (error) ->
  console.error error
  process.exit 1
