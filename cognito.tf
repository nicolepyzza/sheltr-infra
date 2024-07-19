# resource "aws_cognito_user_pool" "sheltr_user_pool" {
#   name                   = "sheltr_user_pool"
#   username_attributes    = ["email"]
#   auto_verified_attributes = ["email"]

#   password_policy {
#     minimum_length    = 8
#     require_lowercase = true
#     require_uppercase = true
#     require_numbers   = true
#     require_symbols   = true
#   }

#   schema {
#     attribute_data_type = "String"
#     name                = "email"
#     required            = true
#     mutable             = false
#   }

#   admin_create_user_config {
#     allow_admin_create_user_only = true
#   }

#   verification_message_template {
#     email_message = "Your verification code is {####}"
#     email_subject = "Verify your email for Sheltr"
#     sms_message   = "Your verification code is {####}"
#   }
# }

# resource "aws_cognito_user_pool_client" "sheltr_user_pool_client" {
#   name           = "sheltr_user_pool_client"
#   user_pool_id   = aws_cognito_user_pool.sheltr_user_pool.id
#   generate_secret = false
# }

# resource "aws_cognito_identity_pool" "sheltr_identity_pool" {
#   identity_pool_name           = "sheltr_identity_pool"
#   allow_unauthenticated_identities = false

#   cognito_identity_providers {
#     client_id       = aws_cognito_user_pool_client.sheltr_user_pool_client.id
#     provider_name   = aws_cognito_user_pool.sheltr_user_pool.endpoint
#   }
# }

# resource "aws_iam_role" "cognito_authenticated_role" {
#   name = "Cognito_sheltr_Authenticated_Role"

#   assume_role_policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Principal": {
#           "Federated": "cognito-identity.amazonaws.com"
#         },
#         "Action": "sts:AssumeRoleWithWebIdentity",
#         "Condition": {
#           "StringEquals": {
#             "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.sheltr_identity_pool.id}"
#           },
#           "ForAnyValue:StringLike": {
#             "cognito-identity.amazonaws.com:amr": "authenticated"
#           }
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "cognito_authenticated_policy" {
#   name   = "Cognito_sheltr_Authenticated_Policy"
#   role   = aws_iam_role.cognito_authenticated_role.id
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": [
#           "mobileanalytics:PutEvents",
#           "cognito-sync:*",
#           "cognito-identity:*"
#         ],
#         "Resource": "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role" "cognito_unauthenticated_role" {
#   name = "Cognito_sheltr_Unauthenticated_Role"

#   assume_role_policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Principal": {
#           "Federated": "cognito-identity.amazonaws.com"
#         },
#         "Action": "sts:AssumeRoleWithWebIdentity",
#         "Condition": {
#           "StringEquals": {
#             "cognito-identity.amazonaws.com:aud": "${aws_cognito_identity_pool.sheltr_identity_pool.id}"
#           },
#           "ForAnyValue:StringLike": {
#             "cognito-identity.amazonaws.com:amr": "unauthenticated"
#           }
#         }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy" "cognito_unauthenticated_policy" {
#   name   = "Cognito_sheltr_Unauthenticated_Policy"
#   role   = aws_iam_role.cognito_unauthenticated_role.id
#   policy = jsonencode({
#     "Version": "2012-10-17",
#     "Statement": [
#       {
#         "Effect": "Allow",
#         "Action": [
#           "mobileanalytics:PutEvents",
#           "cognito-sync:*"
#         ],
#         "Resource": "*"
#       }
#     ]
#   })
# }

# resource "aws_cognito_identity_pool_roles_attachment" "sheltr_identity_pool_roles" {
#   identity_pool_id = aws_cognito_identity_pool.sheltr_identity_pool.id
#   roles = {
#     "authenticated"   = aws_iam_role.cognito_authenticated_role.arn
#     "unauthenticated" = aws_iam_role.cognito_unauthenticated_role.arn
#   }
# }