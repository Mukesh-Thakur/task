data "aws_iam_policy_document" "S3_automation_move_objects" {
  statement {
    sid       = "allowS3"
    actions   = ["s3:GetObject", "s3:DeleteObject"]
    resources = ["arn:aws:s3:::${var.source_bucket_name}/${var.source_bucket_prefix}/*"]
  }

  statement {
    sid     = "allowListBucket"
    actions = ["s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${var.source_bucket_name}",
      "arn:aws:s3:::${var.source_bucket_name}/${var.source_bucket_prefix}/*"
    ]
  }

  statement {
    sid       = "putObject"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.destination_bucket_name}/${var.source_bucket_prefix}/*"]
  }
}

resource "aws_iam_policy" "S3_automation_move_objects" {
  name        = "S3_automation_move_objects"
  description = "test - access to source and destination S3 bucket"
  path        = "/"
  policy      = data.aws_iam_policy_document.S3_automation_move_objects.json
}

resource "aws_iam_role" "S3_automation_move_objects" {
  name        = "S3_automation_move_objects"
  description = "test - access to source and destination S3 bucket"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Effect    = "Allow"
        Sid       = ""
        Principal = { Service = "ec2.amazonaws.com" }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "S3_automation_move_objects" {
  role       = aws_iam_role.S3_automation_move_objects.name
  policy_arn = aws_iam_policy.S3_automation_move_objects.arn
}
