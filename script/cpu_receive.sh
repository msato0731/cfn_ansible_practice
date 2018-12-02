#! /bin/bash
REGION='ap-northeast-1'
SQS_QUEUE_NAME='kadai-SQS-SQSQueue-TLLIHM9PJ2N0'
LOGFILE='/tmp/cpu_use.log'

# Get  Queue URL
SQS_QUEUE_URL=$(aws sqs get-queue-url --queue-name ${SQS_QUEUE_NAME} --output text --region ${REGION} )      

# Create msg file
FILE_SQS_MSG="/home/ec2-user/script/${SQS_QUEUE_NAME}-msg".json

# Receive Queue Message
aws sqs receive-message --queue-url ${SQS_QUEUE_URL} --region ${REGION} > ${FILE_SQS_MSG}

# Get Handle id
SQS_RECEIPT_HANDLE=$(cat ${FILE_SQS_MSG} | jq -r '.Messages[].ReceiptHandle')

# Create body file
FILE_SQS_BODY="/home/ec2-user/script/${SQS_QUEUE_NAME}-body".json
cat ${FILE_SQS_MSG} | jq -r '.Messages[].Body' > ${FILE_SQS_BODY}

# Get Body Message
SQS_RECEIPT_BODY=$(cat ${FILE_SQS_BODY} | jq -r '.Message')

# Loggin message
LOGGING_TIME=$(date "+%Y%m%d-%H:%M:%S")
echo $LOGGING_TIME $SQS_RECEIPT_BODY >> ${LOGFILE} 

# Delete message
aws sqs delete-message --queue-url "${SQS_QUEUE_URL}" --receipt-handle ${SQS_RECEIPT_HANDLE} --region ${REGION}
