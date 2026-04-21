#!/usr/bin/env sh

mermaid_path=docs/_mermaid
mermaid_img_path=docs/_mermaid/_images

# Clean generated svg files
find $mermaid_img_path -type f -name "*.svg" -delete

# Generate svg files
for file in $(find $mermaid_path -type f -name "*.md")
do
  echo "Markdown input $file:"
  dir_md=$(dirname "$file")
  dir_relative=${dir_md#*docs/_mermaid/}
  dir_output="$mermaid_img_path/$dir_relative"
  mkdir -p $dir_output
  name=$(basename "$file" .md)
  node_modules/.bin/mmdc -i $file -o "$dir_output/$name.svg"
done
