#!/bin/sh

set -e

WORKING_DIR=$1
GITHUB_TOKEN=$2
SUCCESS=0

cd ${GITHUB_WORKSPACE}/${WORKING_DIR}

set +e
OUTPUT=$(golint -set_exit_status ./... 2>&1)
SUCCESS=$?
set -e

if [ ${SUCCESS} -eq 0 ]; then
    exit ${SUCCESS}
else
    COMMENT="ERROR golint check has failed
$(echo "${OUTPUT}")"

    echo ${COMMENT}
    # Send comment to PR
    PAYLOAD=$(echo '{}' | jq --arg body "${COMMENT}" '.body = $body')
    COMMENTS_URL=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
    curl -s -S -H "Authorization: token ${GITHUB_TOKEN}" --header "Content-Type: application/json" --data "${PAYLOAD}" "${COMMENTS_URL}" > /dev/null
fi

exit ${SUCCESS}
