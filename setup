git config --global user.name "$GIT_USERNAME"
git config --global user.email "$GIT_EMAIL"
if [ $GITHUB_USERNAME ]; then
    pushd tvm

    EXISTS=$(git remote -v | grep -c "working git" | wc -l)
    REPO="git@github.com:$GITHUB_USERNAME/tvm.git"

    if [ $EXISTS -ne 0 ] ; then
        git remote remove working
    fi
    git remote add working $REPO
    popd
fi
