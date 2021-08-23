resource "aws_iam_role" "fflag_lambda" {

  name = "iam_for_fflag_lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_lambda_function" "check_foo" {

    filename = "archive.zip"
    function_name = "checkFoo"
    role = aws_iam_role.fflag_lambda.arn
    handler = "index.lambda_handler"
    runtime       = "python3.8"

}

resource "aws_cloudwatch_event_rule" "every_five_minutes" {
  
    # name = "every-five-minutes"
    # description = "Fires every five minutes"
    # schedule_expression = "rate(5 minutes)"



    name = "capture-ssm-parameter-featureflag"
    description = "captures changes to the Canary feature flag (Yet/No)"

    event_pattern = jsonencode({ "source" : ["aws.ssm"] , "detail-type": ["Parameter Store Change"],"detail": {"name": ["/canaries/ServiceFirst/Active"],
            "operation": [
                "Update"
                ]
        } })
  
}


resource "aws_cloudwatch_event_target" "check_foo_every_five_minutes" {
    rule = "${aws_cloudwatch_event_rule.every_five_minutes.name}"
    target_id = "check_foo"
    arn = "${aws_lambda_function.check_foo.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_check_foo" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.check_foo.function_name}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.every_five_minutes.arn}"
}