FOLDER=$(echo $GITHUB_REPOSITORY | cut -d'/' -f2)

git clone https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git
cd $FOLDER
git checkout $OUTDATED_BRANCH

echo Adding origin as $GITHUB_REPOSITORY
git remote set-url origin https://x-access-token:$GITHUB_TOKEN@github.com/$GITHUB_REPOSITORY.git
git config --global user.email "$USER_EMAIL"
git config --global user.name "$USER_NAME"

git fetch origin $BASE_BRANCH

echo git pull --rebase origin $OUTDATED_BRANCH
git pull --rebase origin $OUTDATED_BRANCH

echo Rebasing $BASE_BRANCH onto $OUTDATED_BRANCH
echo git rebase origin/$BASE_BRANCH
git rebase origin/$BASE_BRANCH

echo git push --force-with-lease origin $OUTDATED_BRANCH
git push --force-with-lease origin $OUTDATED_BRANCH

cd ..
rm -rf $FOLDER