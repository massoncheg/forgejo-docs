#!/usr/bin/env sh

current_branch=$(git branch --show-current)
repo_path=$(pwd)
mermaid_path=$repo_path/docs/_mermaid
mermaid_img_path=$repo_path/docs/_mermaid/_images

# Clean generated svg files
for file in $(find $mermaid_img_path -type f -name "*.svg" -printf "%p\n")
do
  rm $file
done

# Generate svg files
for file in $(find $mermaid_path -path $mermaid_img_path -prune -o -type f -name "*.md" -printf "%p\n")
do
  echo "MD FILE: $file"
  dir_md=$(dirname "$file")
  dir_relative=${dir_md#*docs/_mermaid/}
  dir_output=$(echo "$mermaid_img_path/$dir_relative")
  mkdir -p $dir_output
  name=$(basename "$file" ".md")
  $repo_path/node_modules/.bin/mmdc -i $file -o $(echo "$dir_output/$name.svg")
done