################################################################################################
## you can use the following line to call this bash: 
##  source ./login-aws-iam.bash oclab arn:aws:iam::446490546198:role/oclab-infra
################################################################################################
profile_name=$1
role_arn=$2
# role_arn= "arn:aws:iam::446490546198:role/oclab-infra"
Duration=2

# if [[ -z $1 ]]; then exit 1 fi
# if [[ -z $2 ]]; then  exit 1 fi

export AWS_PROFILE="$profile_name"

# export AWS_PROFILE=oclab
# export ASSUME_ROLE_JSON=$(aws sts assume-role --role-arn $ROLE_ARN --role-session-name sls-tf --no-verify-ssl)
assume_role_result_json=$(aws sts assume-role --role-arn $role_arn --role-session-name sls-tf --no-verify-ssl)
AccessKeyId=$(echo $assume_role_result_json | jq '.Credentials.AccessKeyId' | tr -d \")
SecretAccessKey=$(echo $assume_role_result_json | jq '.Credentials.SecretAccessKey' | tr -d \")
SessionToken=$(echo $assume_role_result_json | jq '.Credentials.SessionToken' | tr -d \")

# use this line to create a new PROFILE and use it. 



aws configure set aws_access_key_id $AccessKeyId --profile aws-sls-tf
aws configure set aws_secret_access_key $SecretAccessKey --profile aws-sls-tf
aws configure set aws_session_token $SessionToken --profile aws-sls-tf


export AWS_PROFILE=aws-sls-tf

# or uncomment the followign lines if you don't want to create a profile and use the env. variables instead!

# export AWS_ACCESS_KEY_ID=$AccessKeyId
# export AWS_SECRET_ACCESS_KEY=$SecretAccessKey
# export AWS_SESSION_TOKEN=$SessionToken
# aws sts get-caller-identity | cat