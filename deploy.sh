#!/bin/bash
set -e # Exit with nonzero exit code if anything fails

# Expects that the build script will place the contents of gh-pages into out/.
# Expects that the before_deploy steps will place a deploy key in ./deploy_key.

TARGET_BRANCH=gh-pages

# Save some useful information
REPO=`git config remote.origin.url`
SSH_REPO=${REPO/https:\/\/github.com\//git@github.com:}
SHA=`git rev-parse --verify HEAD`

CLONED_TARGET_BRANCH=$(mktemp -d)
# Clone the existing gh-pages for this repo into out/
git clone --depth 1 --branch $TARGET_BRANCH $REPO $CLONED_TARGET_BRANCH

# Copy over the out/ directory, removing any old contents.
rsync -r --exclude .git --delete out/ $CLONED_TARGET_BRANCH

# Install the deploy key.
chmod 600 deploy_key
eval `ssh-agent -s`
if ! ssh-add deploy_key; then
    echo "Unable to add SSH identity; exiting."
    exit 1
fi

# Now let's go have some fun with the cloned repo
cd $CLONED_TARGET_BRANCH
# If there are no changes to the compiled out (e.g. this is a README update) then just bail.
if git diff --quiet; then
    echo "No changes to the output on this push; exiting."
    exit 0
fi

git config user.name "Travis CI"
git config user.email "$COMMIT_AUTHOR_EMAIL"

# Commit the "changes", i.e. the new version.
# The delta will show diffs between new and old versions.
git add -A .
git commit -m "Deploy to GitHub Pages: ${SHA}"

# Now that we're all set up, we can push.
git push $SSH_REPO $TARGET_BRANCH

