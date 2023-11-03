#!/bin/bash

mongo_credentials=`gcloud secrets versions access latest --secret=newyeti_mongo_credentials`
bq_credentials=`gcloud secrets versions access latest --secret=newyeti_bq_credentials`
infra_credentials=`gcloud secrets versions access latest --secret=upstash_infra_credentials`
rapid_api_keys=`gcloud secrets versions access latest --secret=rapid-api-keys`

get_credentials() {
    type=$1
    json_key=$2

    if [[ ${type} == "mongo" ]]; then
        echo $( jq -r  $json_key <<< "${mongo_credentials}" )
    elif [[ ${type} == "infra" ]]; then
        echo $( jq -r  $json_key <<< "${infra_credentials}" )
    fi
}


app_env=$(echo $APP_ENV)

if [[ -z "${app_env}" ]]; then
    app_env="dev"
fi

echo "Setting '${app_env}' envrionment variables"

env_infra="dev"
env_mongo="dev"
env_file=".env"

if [[ ${app_env} == "prod" ]]; then
    env_infra="control_cluster"
    env_mongo="prod"
    env_file="prod.env"
fi

if [[ -f ${env_file} ]]; then
    rm -rf ${env_file}
fi

export APP_ENV=${app_env}

#Mongo DB
MONGO_HOSTNAME=$(get_credentials "mongo" ".${env_mongo}.hostname")
MONGO_USERNAME=$(get_credentials "mongo" ".${env_mongo}.username")
MONGO_PASSWORD=$(get_credentials "mongo" ".${env_mongo}.password")
MONGO_DB="football"
MONGO_JSON_FMT='{"HOSTNAME": "%s", "USERNAME": "%s", "PASSWORD": "%s", "DB": "%s"}'
MONGO=$(printf "${MONGO_JSON_FMT}" "${MONGO_HOSTNAME}" "${MONGO_USERNAME}" "${MONGO_PASSWORD}" "${MONGO_DB}")


#BigQuery
BIGQUERY_CREDENTIAL_JSON_FMT='{"CREDENTIAL": "%s"}'
BIGQUERY=$(printf "${BIGQUERY_CREDENTIAL_JSON_FMT}" "${bq_credentials}" )

#Redis
REDIS_HOSTNAME=$(get_credentials "infra" ".${env_infra}.redis.hostname")
REDIS_PORT=$(get_credentials "infra" ".${env_infra}.redis.port")
REDIS_PASSWORD=$(get_credentials "infra" ".${env_infra}.redis.password")
REDIS_SSL_ENABLED=True
REDIS_JSON_FMT='{"HOSTNAME": "%s", "PORT": "%s", "USERNAME": "%s", "PASSWORD": "%s", "SSL_ENABLED": "%s"}'

REDIS=$(printf "${REDIS_JSON_FMT}" "${REDIS_HOSTNAME}" "${REDIS_PORT}" "${REDIS_USERNAME}" "${REDIS_PASSWORD}" "${REDIS_SSL_ENABLED}")

#Kafka
KAFKA_BOOTSTRAP_SERVERS=$(get_credentials "infra" ".${env_infra}.kafka.bootstrap_servers")
KAFKA_USERNAME=$(get_credentials "infra" ".${env_infra}.kafka.username")
KAFKA_PASSWORD=$(get_credentials "infra" ".${env_infra}.kafka.password")
KAFKA_JSON_FMT='{"BOOTSTRAP_SERVERS": "%s","USERNAME": "%s", "PASSWORD": "%s"}'
KAFKA=$(printf "${KAFKA_JSON_FMT}" "${KAFKA_BOOTSTRAP_SERVERS}" "${KAFKA_USERNAME}" "${KAFKA_PASSWORD}") > $env_file


#Rapid API Keys (comma separated list)
API_KEYS_JSON_FMT='{"API_KEYS": "%s"}'
RAPID_API=$(printf "${API_KEYS_JSON_FMT}" "${rapid_api_keys}" ) > $env_file

cat <<EOF
{
  "MONGO": "$MONGO",
  "BIGQUERY": "$BIGQUERY",
  "REDIS": "$REDIS",
  "KAFKA": "$KAFKA",
  "RAPID_API": "$RAPID_API"
}
EOF

echo "Setting app_env variables completed."