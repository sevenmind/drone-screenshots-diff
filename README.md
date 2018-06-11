# Drone Plugin for Screenshots Diff

Imagine you are running acceptance tests producing a series of screenshots of your website, iOS app or whatever. Once you're implementing new features or fixes you're creating new branches accordingly and use pull requests to merge them in after your collegues had a look on it. 

Wouldn't it be nice to have the screenshots showing your work attached to your *pull request* without doing a manual job? This is exactly what this plugin is for. Under the hood the screenshots are copied to Google File Storage on each commit and once you create your PR, the files are compared against a reference branch. Newly added files and changed images are added to the Bitbucket Pull Request.


    screenshots:
      image: 7mind/drone-screenshots-diff:latest
      google_auth_key: <service-account-token>
      project: <google-project-id>
      bucket: <exiting-google-file-storage-bucket>
      folder: <subfolder-in-bucket>
      branch: "${DRONE_COMMIT_BRANCH}"
      ref: develop
      source: <source-image-directory>
      pr: $CI_PULL_REQUEST
      bitbucket_user: <email>
      bitbucket_password: <password>

## Parameter Reference

```google_auth_key```
Base64 encoded json key of a service account with write access to the *bucket* located in the *project*.

```project```
Google project id

```bucket```
Goole File Storage bucket name

```folder```
Subfolder in the *bucket*.

```branch```
Current commit branch.

```ref```
Reference branch for comparison. Eg if you follow gitflow this is probably `develop`.

```source```
Source directory containing all the images to upload.

```pr```
Current Pull Request Id. Eg. $CI_PULL_REQUEST

```bitbucket_user```
Bitbucket user email

```bitbucket_password```
Bitbucket user password



