#!/bin/bash

maxRetries=5
failedCount=0
retryCount=0
successCount=0

# store the current dir
CUR_DIR=$(pwd)

# Let the person running the script know what's going on.
echo -e "\n\033[1mFetching latest changes for all repositories...\033[0m\n"

# Find all git repositories and update it to the master latest revision
for i in $(find . -name .git -type d | cut -c 3-); do
    echo ""
    echo -e "\033[33m"+$i+"\033[0m"

    # We have to go to the .git parent directory to call the pull command
    cd "$i"
    cd ..

    n=0
    until [ $n -ge $maxRetries ]
    do
        if [ $n -gt 0 ]; then echo "Retry $n of $maxRetries..."; fi
        if git fetch --all --tags --prune --prune-tags --recurse-submodules
        then
            successCount=$((successCount + 1))
            break
        fi
        n=$((n + 1))
        retryCount=$((retryCount + 1))
    done
    if [ $n -ge $maxRetries ]; then failedCount=$((failedCount + 1)); fi

    # lets get back to the CUR_DIR
    cd $CUR_DIR
done

echo -e "\n\033[32mComplete!\033[0m\n"
echo "Success: $successCount"
if [ $retryCount -gt 0 ]; then echo "Retries: $retryCount"; fi
if [ $failedCount -gt 0 ]
then
    echo "Failed: $failedCount"
    exit 1
fi

exit 0