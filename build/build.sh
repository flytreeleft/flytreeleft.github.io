#! /bin/bash

git pull origin master
git reset --hard origin/master
git clean -d -f

repo=`git remote get-url origin`
branch=blog
if [ ! -d blog ]; then
    echo "No blog found yet, clone a new copy from $repo."
    git clone $repo -b $branch blog
fi

pushd blog
echo "Syncing blog with remote ..."
git pull origin $branch
git reset --hard origin/$branch

echo "Building blog ..."
npm install && npm run clean && npm run build
popd

echo "Copying blog dist files ..."
cp -r blog/dist/* .

echo "Commit new dist files."
git add *
git commit -m "Site updated"

echo "Push dist files to repository."
git push origin master
