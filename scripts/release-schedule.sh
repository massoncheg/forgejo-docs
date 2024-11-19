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

| **Version** | **Cut branch** | **Release date** | **End Of Life** |
| ----------- | -------------- | ---------------- | --------------- |
EOF
	jq --raw-output '
def date: .|strptime("%Y-%m-%d")|strftime("%e %B %Y");
def bold: "**\(.)**";

.[] | "| "
+ "\(.major).\(.minor)\(if .lts then " (LTS)" else "" end) |"
+ "\(.cut|date) |"
+ "\(.release|date) |"
+ "\(if .lts then .eol|date|bold else .eol|date end) |"
' release-schedule.json
) >$dir/release-schedule.md
