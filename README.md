# cockroachdb-backup-dockerfiles

Dockerfiles that have the `cockroach` binary and `gcloud`.

# Usage

## Kubernetes

The example cronjob provided runs every night at midnight and runs `cockroach dump`, followed by `curl` to send it to an S3 bucket or a Google storage bucket.

**NOTE** The CronJob resource requires kubernetes version >= 1.8.

```
vim kubernetes/cronjob.yaml
```

Modify the job to match your credentials.

# Configuration

| Environment Variable | Default Value  | |
|----------------------|----------------|-|
| COCKROACH_URL        |     | |
| COCKROACH_DATABASE   | database       | |
| CLOUD_PROVIDER       | gcp            | "gcp" or "aws |
| AWS_S3_BUCKET        | my-bucket      | |
| AWS_S3_KEY           | my-s3-key      | |
| AWS_S3_SECRET        | my-s3-secret   | |
| GCP_BUCKET_NAME      | my-gcp-bucket  | |
| GCP_SA_USER          | cockroach-backup-sa@my-project-123.iam.gserviceaccount.com | The username of the SeriveAccount assigned to the provided key file (see blow) |

# Google Cloud Storage

Usage with Google Cloud Storage is fairly simple.

### Create a ServiceAccount

This service account will have access to the Storage services in your project

```
gcloud iam service-accounts create cockroach-backup-sa --display-name "CockroachDB Backup Account"
```

### Create the key for this service account

This key will be given to the Kubernetes job to authenticate to your gcloud account.

```
gcloud iam service-accounts keys create \
  key.json \
  --iam-account cockroach-backup-sa@my-project-123.iam.gserviceaccount.com
```

### Grant the proper roles (roles/storage.objectCreator)

Now grant the backup service account the ability to add items to Storage

```
gcloud projects add-iam-policy-binding my-project-123 \
  --member serviceAccount:cockroach-backup-sa@my-project-123.iam.gserviceaccount.com \
  --role roles/storage.objectCreator
```

### Now turn it into a Kubernetes secret

```
kubectl create secret generic cockroach-backup-sa --from-file=./key.json
```

# AWS

Currently untested.
