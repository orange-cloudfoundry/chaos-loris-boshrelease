#!/usr/bin/env sh

#
# Copyright (C) 2017 Orange
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

set -e

if [ -z "$AWS_ACCESS_KEY_ID" ]; then
  echo "must specify \$AWS_ACCESS_KEY_ID" >&2
  exit 1
fi
if [ -z "$AWS_SECRET_ACCESS_KEY" ]; then
  echo "must specify \$AWS_SECRET_ACCESS_KEY" >&2
  exit 1
fi
if [ -z "$BUCKET_NAME" ]; then
  echo "must specify \$BUCKET_NAME" >&2
  exit 1
fi

AWS_REGION=${AWS_DEFAULT_REGION:-us-east-1}

aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
aws configure set default.region ${AWS_REGION}


set -x
aws s3api create-bucket --bucket ${BUCKET_NAME} --acl public-read
#--create-bucket-configuration LocationConstraint=${AWS_REGION}

AWS_POLICY='{ "Statement": [ {"Action": "s3:GetObject","Effect": "Allow","Resource": "arn:aws:s3:::'${BUCKET_NAME}'/*","Principal": { "AWS": "*" } } ] }'

aws s3api put-bucket-policy --bucket ${BUCKET_NAME} --policy "$AWS_POLICY"
