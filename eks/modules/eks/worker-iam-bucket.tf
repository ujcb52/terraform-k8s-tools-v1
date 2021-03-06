# worker iam role

resource "aws_iam_role" "bucket" {
  name = "${var.cluster_name}-worker-bucket"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    },
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.workers[0].arn}"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy_attachment" "bucket" {
  role       = aws_iam_role.bucket.name
  policy_arn = aws_iam_policy.bucket.arn
}

resource "aws_iam_policy" "bucket" {
  name = "${var.cluster_name}-worker-bucket"
  # name        = "${aws_iam_role.workers[0].name}-bucket"
  description = "S3 Bucket policy for ${var.cluster_name}"
  policy      = data.aws_iam_policy_document.bucket.json
  path        = "/"
}

data "aws_iam_policy_document" "bucket" {
  statement {
    sid = "eksWorkerBucketRead"
    actions = [
      "s3:*",
    ]
    resources = [
      "arn:aws:s3:::*",
    ]
  }
}
