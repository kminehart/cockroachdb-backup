date=`date +%Y-%m-%d.%H.%M.%S`
file="${date}-cockroachdb.sql"

cat /google-cloud-sdk/path.bash.inc
if [ "${CLOUD_PROVIDER}" = "aws" ]
then
  echo "AWS selected. Starting cockroach dump..."
  # cockroach dump reads the environment variables
  cockroach dump -u ${COCKROACH_USER} --insecure > "/tmp/${file}.sql"
fi

if [ "${CLOUD_PROVIDER}" = "gcp" ]
then
  url="https://storage.googleapis.com/${GCP_BUCKET_NAME}/${file}"

  # Dump cockroachdb
  echo "Dumping database"
  /cockroach dump ${COCKROACH_DATABASE} -u ${COCKROACH_USER} --insecure > "/tmp/${file}"
  echo "Dump completed.  Uploading /tmp/${file} to ${url}"

  echo "Generating GCP token..."
  /google-cloud-sdk/bin/gcloud auth activate-service-account "${GCP_SA_USER}" --key-file=/gcp/key.json

  cat "/tmp/${file}"
  curl -v --upload-file "/tmp/${file}" \
    -H "Authorization: Bearer `/google-cloud-sdk/bin/gcloud auth print-access-token ${GCP_SA_USER}`" \
    "${url}"
fi
