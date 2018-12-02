#! /bin/bash
# SNS TOPIC ARN SET
SNS_TOPIC_ARN='arn:aws:sns:ap-northeast-1:949637840634:kadai-prod-SNSTopic'

# SNS MESSAGE BODY SET
INSTANCE=$(curl 169.254.169.254/latest/meta-data/instance-id/)
SNS_MSG_BODY=$(cat /proc/loadavg | cut -d ' ' -f 1)

# SNS MESSAGE SUBJECT SET
SNS_MSG_SUBJECT='CPU Message'

# REGION SET
REGION='ap-northeast-1'

# SNS Publish
aws sns publish \
        --topic-arn ${SNS_TOPIC_ARN} \
        --message "${SNS_MSG_BODY}" \
        --subject "${SNS_MSG_SUBJECT}"\
        --region "${REGION}"
