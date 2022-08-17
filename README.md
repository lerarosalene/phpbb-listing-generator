# phpBB listing generator

Simple CLI utility that takes list of files (one file per line) and generates phpBB markup
with their contents. It assumes availability of `[FIELDSET]` and `[CODE]` tags.

```
bb-listing <infile> <outfile> [tag descriptors]
  tag descriptor defines extension to BB code correspondance
  for example: bb-listing listing.txt listing.md ".js=JS,.html=HTML"
  extensions not found in this mapping will use [CODE] as fallback
  if file has no extension, it's name is considered extension as a whole (without leading dot)
```
