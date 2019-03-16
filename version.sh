#!/bin/sh
set -e

GIT_REV=$(git log --pretty=format:'%h' -n 1)
GIT_DIFF=$(git diff --quiet --exit-code || echo +)
GIT_TAG=$(git describe --exact-match --tags 2> /dev/null || echo "")
GIT_BRANCH=$(git rev-parse --abbrev-ref HEAD)

VERSION=$(cat << EOF
const char* GIT_REV="${GIT_REV}${GIT_DIFF}";
const char* GIT_TAG="${GIT_TAG}";
const char* GIT_BRANCH="${GIT_BRANCH}";
EOF
)

TARGET=build/version.c
PREV=$(cat $TARGET 2> /dev/null || echo '')
if [ "$VERSION" != "$PREV" ]
then
    echo "SAVING NEW VERSION FILE"
    echo "$VERSION" > $TARGET
fi
