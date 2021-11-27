output "pre_token_lambda" {
  value = module.pre_token_lambda.lambda_output
}

output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
}