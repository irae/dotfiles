#!/bin/bash

# intended for one repo only, or a monorepo.
# if your monorepo contain open-source forks, kindly exclude from the stats

PWD=`pwd`
REPO=`basename $PWD`

echo "repo-name: ${REPO}"
mkdir -p "${REPO}-stats"

git shortlog -s -n --all > "./${REPO}-stats/authors.commits.all.txt"

git shortlog -sn --all --since="01 Jul 2022" > "./${REPO}-stats/authors.commits.recent.txt"

npm ls --depth 0 --json > "./${REPO}-stats/deps.summary.json"

npm outdated --json > "./${REPO}-stats/deps.outdated.json"

npm audit --omit dev --audit-level high --json > "./${REPO}-stats/deps.audit.prod.high.json"

find . -type f | grep -v 'node_modules' | wc -l > "./${REPO}-stats/files.count.txt"

find . -type f | grep -v 'node_modules' | grep -E '(test|spec)' | wc -l > "./${REPO}-stats/files.count.test.txt"

find . -type f | grep -v 'node_modules' | grep -E '(js|jsx|ts|tsx|es|cjs|mjs|json|yaml|yml)$' | wc -l > "./${REPO}-stats/files.source.count.txt"

tar cfzv "${REPO}-stats.tar.gz" "${REPO}-stats"

rm $REPO-stats/*.*

rmdir "${REPO}-stats"