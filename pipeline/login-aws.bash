
# typicall the user name is FASTAWSNonProdAgent@firstam.com

DefaultRegion="us-west-2"
TenantId="9ca75128-a244-4596-877b-f24828e476e2"
RoleArn="arn:aws:iam::539790979880:role/AWS-InnovationLabs-Beta-Admin"
ProfileName="aws-sls-tf"
Duration=2


AZURE_DEFAULT_USERNAME=$UserName
AZURE_DEFAULT_PASSWORD=$Password
AZURE_TENANT_ID=$TenantId
AZURE_APP_ID_URI="https://signin.aws.amazon.com/saml\#3"
AZURE_DEFAULT_ROLE_ARN=$RoleArn
AZURE_DEFAULT_DURATION_HOURS=$Duration

AWS_PROFILE=$ProfileName

aws configure set azure_tenant_id $TenantId --profile "$ProfileName"
aws configure set azure_app_id_uri "https://signin.aws.amazon.com/saml\#3" --profile "$ProfileName"
aws configure set azure_default_username $UserName --profile "$ProfileName"
aws configure set azure_default_password $Password --profile "$ProfileName"

aws configure set azure_default_role_arn $RoleArn --profile "$ProfileName"
aws configure set azure_default_duration_hours $Duration --profile "$ProfileName"
aws configure set region $DefaultRegion --profile "$ProfileName"

# ProfileName="fast-n-1-prog"
export AWS_PROFILE=$ProfileName

# case $AssumeRole in 
#     "s3build") 
#         aws configure set role_arn arn:aws:iam::614296884338:role/fast-s3-build --profile fast-n-1-s3build
#         aws configure set source_profile "$ProfileName" --profile fast-n-1-s3build
#         echo $AssumeRole
#         ;;
    
#     "infra") 
#         aws configure set role_arn arn:aws:iam::614296884338:role/fast-infrastructure --profile fast-n-1-infra
#         aws configure set source_profile "$ProfileName" --profile fast-n-1-infra
#         echo $AssumeRole
#         ;;
    
# esac




# ProfileName="fast-n-1-prog"
aws-azure-login --no-prompt --profile $ProfileName

# aws sts assume-role --role-arn arn:aws:iam::539790979880:role/AWS-InnovationLabs-Beta-Admin
export AWS_PROFILE=oclab
AssumRoleResultJson=$(aws sts assume-role --role-arn arn:aws:iam::446490546198:role/oclab-infra --role-session-name sls-tf --no-verify-ssl)
AccessKeyId=$(echo $AssumRoleResultJson | jq '.Credentials.AccessKeyId'| tr -d \") 
SecretAccessKey=$(echo $AssumRoleResultJson | jq '.Credentials.SecretAccessKey' | tr -d \")
SessionToken=$(echo $AssumRoleResultJson | jq '.Credentials.SessionToken' | tr -d \")

export AWS_ACCESS_KEY_ID=$AccessKeyId
export AWS_SECRET_ACCESS_KEY=$SecretAccessKey
export AWS_SESSION_TOKEN=$SessionToken

unset AWS_PROFILE


# echo "NOTE: you need to set the following env. variables only when using additional shell sessions: "
# echo "export AWS_ACCESS_KEY_ID="$AccessKeyId
# echo "export AWS_SECRET_ACCESS_KEY="$SecretAccessKey
# echo "export AWS_SESSION_TOKEN="$SessionToken


