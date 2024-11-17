#!/bin/bash

set -e

if ! which jq >/dev/null; then
	apt-get install -qq -y jq
fi

dir=docs/admin

tag="<!-- lines below are replaced -->"
schedule="$(sed -e "/$tag/,20000d" <$dir/release-schedule.md)"

(
	cat <<EOF
$schedule
$tag

| **LTS** | **Version** | **Cut branch** | **Release date** | **End Of Life** |
| ------- | ----------- | -------------- | ---------------- | --------------- |
EOF
	jq --raw-output '.[] | "| \(.lts) | \(.major).\(.minor) | \(.cut) | \(.release) | \(.eol) |"' <release-schedule.json
) >$dir/release-schedule.md
