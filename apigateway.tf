# resource "aws_lambda_function" "sheltr_lambda" {
#   filename         = "profiles.zip"
#   function_name    = "sheltr_profiles"
#   role             = aws_iam_role.lambda_exec_role.arn
#   handler          = "index.handler"
#   runtime          = "nodejs20.x"
#   source_code_hash = filebase64sha256("profiles.zip")
# }