#!/bin/sh

# authenticate
echo $PLUGIN_AUTH_KEY | base64 -d > /auth_key.json

gcloud auth activate-service-account --key-file=/auth_key.json --project $PLUGIN_PROJECT

TARGET_PATH=$PLUGIN_BUCKET/$PLUGIN_FOLDER/$PLUGIN_COMMIT
REF_PATH=$PLUGIN_BUCKET/$PLUGIN_FOLDER/$PLUGIN_REF

set

# upload new screenshots
cd 
gsutil -m cp $DRONE_WORKSPACE/$PLUGIN_SOURCE/* gs://$TARGET_PATH

# copy new screenshots to comparison folder
mkdir -p /compare/a
cp $DRONE_WORKSPACE/$PLUGIN_SOURCE/* /compare/a

# download reference images
mkdir -p /compare/b
gsutil -m cp gs://$REF_PATH/* /compare/b