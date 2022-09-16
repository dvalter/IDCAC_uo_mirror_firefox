#!/bin/bash
set -euo pipefail
MAIN_PATH=$(git -C "$(dirname "$(realpath -s "$1")")" rev-parse --show-toplevel)
cd "$MAIN_PATH"
GIT_SLUG=$(git ls-remote --get-url | sed "s|https://||g" | sed "s|git@||g" | sed "s|:|/|g")

curl -s https://addons.mozilla.org/en-US/firefox/addon/i-dont-care-about-cookies/versions/ | grep -Eo '"https://[^"]*\.xpi"' | tr '"' ' ' | sort > files.list

git config --global user.name || git config --global user.name "${CI_USERNAME}"
git config --global user.email || git config --global user.email "41898282+github-actions[bot]@users.noreply.github.com"

for url in $(cat files.list); do
    version="$(echo $url | grep -Eo '[0-9]+\.[0-9]+\.[0-9]+')"
    git show -q "v$version-ff" && continue
    git rm -rf src
    mkdir -p ./src
    wget "$url"
    cd src
    unzip -o "../i_dont_care_about_cookies-$version.xpi"
    rm -rf mozilla-recommendation.json META-INF
    cd "$MAIN_PATH"
    git add src
    filedate="$(stat -c "%y" "i_dont_care_about_cookies-$version.xpi")"
    git commit -m "Update to FF v$version" --date="$filedate"
    git tag -am "v$version-ff" "v$version-ff" HEAD
done

git push https://"${CI_USERNAME}":"${GIT_TOKEN}"@"${GIT_SLUG}" >/dev/null 2>&1
git push --tags https://"${CI_USERNAME}":"${GIT_TOKEN}"@"${GIT_SLUG}" >/dev/null 2>&1
