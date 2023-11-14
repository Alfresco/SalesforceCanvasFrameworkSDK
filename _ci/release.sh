#!/usr/bin/env bash

echo "=========================== Starting Release Script ==========================="
PS4="\[\e[35m\]+ \[\e[m\]"
set -vex
pushd "$(dirname "${BASH_SOURCE[0]}")/../"

# Travis CI runner work on DETACHED HEAD, so we need to checkout the release branch
git checkout -B "$BRANCH_NAME"

#sync the branch by getting the latest changes
git pull

git config user.email "${GIT_EMAIL}"
git config user.name "${GIT_USERNAME}"

# Run the release plugin - with "[skip ci]" in the release commit message
mvn -B \
  "-Darguments=-DskipTests -Dmaven.javadoc.skip -Dadditionalparam=-Xdoclint:none" \
  release:clean release:prepare release:perform \
  -DscmCommentPrefix="[maven-release-plugin][skip ci] " \
  -Dusername="${GIT_USERNAME}" \
  -Dpassword=${GIT_PASSWORD}

popd
set +vex
echo "=========================== Finishing Release Script =========================="