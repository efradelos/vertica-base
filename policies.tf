data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

data "aws_iam_policy_document" "full_access" {
  statement {
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
    ]

    resources = [
      "arn:aws:s3:::${var.db_communal_storage_bucket}/${var.db_communal_storage_key}/*"
    ]
  }

  statement {
    actions = [
      "s3:ListBucket",
    ]

    resources = [
      "arn:aws:s3:::${var.db_communal_storage_bucket}"
    ]
  }

  statement {
    actions = [
      "ec2-instance-connect:SendSSHPublicKey"
    ]

    resources = [
      "arn:aws:ec2:*:*:instance/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/Cluster"
      values   = [local.cluster_id]
    }
  }

  statement {
    actions = [
      "secretsmanager:GetSecretValue"
    ]

    resources = [
      "arn:aws:secretsmanager:*:*:secret:${var.credentials_secret_id}*"
    ]
  }

  statement {
    actions = [
      "ec2:DescribeInstances",
      "ec2:DescribeTags",
      "ec2:DescribeImages",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeInstanceStatus"
    ]

    resources = [
      "*"
    ]
  }
}
