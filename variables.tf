variable "bucket_name" {
    type        = string
    description = "S3 BucketName"
}

variable "aws_region" {
    default     = "ap-northeast-1"
    type        = string
    description = "AWS Region"
}

variable "ClusterBaseName" {
    type        = string
    description = "ClusterBaseName"
}