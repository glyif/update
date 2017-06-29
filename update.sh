#!/usr/bin/env bash
source config.sh

function find_release() {
	URL="https://api.github.com/repos/$1/releases/latest"
	echo "$URL"
	VERSION=$(curl -s "$URL" | jq -r ".tag_name")
	if [[ "$TYPE" ]]; then
		DOWNLOAD=$(curl -s "$URL" | jq -r ".assets[] | select(.name | test(\"${TYPE}\")) | .browser_download_url")
	else
		DOWNLOAD=$(curl -s "$URL" | jq -r ".assets[] | select(.name) | .browser_download_url")
	fi
}

find_release "$REPO"

function replace_old() {
	wget -O tmp "$DOWNLOAD"
	chmod +x tmp
	sudo mv tmp "$(which "$NAME")"

}

replace_old
