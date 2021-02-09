# worker iam role

resource "aws_iam_role" "adfs-roles" {
  count = length(var.adfs_role_names)
  name  = "AWS-${local.account_id}-${var.adfs_role_names[count.index]["name"]}"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Federated": "arn:aws:iam::${local.account_id}:saml-provider/awsfs"
      },
      "Action": "sts:AssumeRoleWithSAML",
      "Condition": {
        "StringEquals": {
          "SAML:aud": [
            "https://signin.aws.amazon.com/saml"
          ]
        }
      }
    }
  ]
}
POLICY

}
