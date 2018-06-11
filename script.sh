#!/bin/bash

# authenticate at google
authenticate () {

  echo $PLUGIN_GOOGLE_AUTH_KEY | base64 -d > /auth_key.json
  gcloud auth activate-service-account --key-file=/auth_key.json --project $PLUGIN_PROJECT
}

# upload source images to google bucket
upload_files () {
  
  TARGET_PATH=$PLUGIN_BUCKET/$PLUGIN_FOLDER/$PLUGIN_BRANCH
  
  gsutil -m cp -a public-read $DRONE_WORKSPACE/$PLUGIN_SOURCE/* gs://$TARGET_PATH  
}

# check if we should compare now (only for PRs)
check_pr () {

  if [[ -z "$PLUGIN_PR" ]]; then
     echo ">> PR not set, exiting gracefully!"
     exit 0
  fi 
}

# download reference images
download_ref_files () {

  REF_PATH=$PLUGIN_BUCKET/$PLUGIN_FOLDER/$PLUGIN_REF  
  mkdir -p /compare/b
  gsutil -m cp gs://$REF_PATH/* /compare/b
}

# compare files
compare () {

  mkdir -p /compare/a
  cp $DRONE_WORKSPACE/$PLUGIN_SOURCE/* /compare/a

  # compare directories
  cd /compare

  CONTENT="Added screenshots:"

  echo ">> new files"
  while read line
  do
    echo "gs://$TARGET_PATH/$line"
    CONTENT="$CONTENT \n ![](https://storage.googleapis.com/$TARGET_PATH/$line)"
  done <<< $(diff -rq a/ b/ | grep "Only in a/:" | awk '{print $4}')

  echo ">> updated files"
  while read line
  do
    echo "$TARGET_PATH/$match"
    CONTENT="$CONTENT \n ![](https://storage.googleapis.com/$TARGET_PATH/$line)"  
  done <<< $(diff -rq a/ b/ | grep 'differ' | awk '{print $4}') | cut -c 3-
}

# post comment on bitbucket
bitbucket_comment () {

  curl -X "POST" "https://bitbucket.org/!api/1.0/repositories/sevenmind/7mind-www-v2/pullrequests/$PLUGIN_PR/comments/" \
       -H 'Content-Type: application/json; charset=utf-8' \
       -u "$PLUGIN_BITBUCKET_USER:$PLUGIN_BITBUCKET_PASSWORD" \
       -d "{\"content\": \"$CONTENT\"}"
}

# RUN
authenticate
upload_files

check_pr

download_ref_files
compare
bitbucket_comment
