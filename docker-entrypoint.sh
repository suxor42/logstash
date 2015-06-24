#!/bin/bash

set -e



# Add logstash as command if needed
if [[ "$1" == -* ]]; then
	set -- logstash "$@"
fi

# Run as user "logstash" if the command is "logstash"
if [ "$1" == logstash ]; then
	set -- gosu logstash "$@"
fi

if [ -n "$S3_CONFIG_PATH" ]; then
  aws s3 cp --recursive ${S3_CONFIG_PATH} ${LOGSTASH_CONF_DIR} --region ${AWS_DEFAULT_REGION:-"eu-west-1"}
fi

exec "$@" -e "$(eval "cat <<EOF
$(<${LOGSTASH_CONF_DIR}/${LOGSTASH_CONFIG})
EOF
" 2> /dev/null)"
#${LOGSTASH_CONF_DIR}/logstash.conf