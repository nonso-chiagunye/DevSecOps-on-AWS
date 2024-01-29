variable "aws_region" {
  type = string
  default = ""  
}

variable "secret_name" {
  type = string
  default = ""  
}

variable "bucket_name" {
  type = string
  default = ""  
}

variable "ecr_repo" {
  type = string
  default = ""  
}

variable "codecommit_repo" {
  type = string
  default = ""  
}

variable "eks_cluster" {
  type = string
  default = ""  
}

variable "eks_node" {
  type = string
  default = ""  
}

variable "lb_ports" {
    type = list(number)
    default = [80, 443, 3000]
}

variable "lb_security_group" {
  type = string
  default = ""  
}

variable "codebuild_project" {
  type = string
  default = ""  
}

variable "codepipeline_role" {
  type = string
  default = ""  
}

variable "codepipeline_policy" {
  type = string
  default = ""
  
}

variable "codepipeline" {
  type = string
  default = ""  
}

variable "codebuild_role" {
  type = string
  default = ""  
}

variable "codebuild_policy" {
  type = string
  default = ""  
}

variable "cluster_role" {
  type = string
  default = ""  
}

variable "node_role" {
  type = string
  default = ""  
}

variable "node_policy" {
  type = string
  default = ""  
}

variable "vpc" {
  type = string
  default = ""  
}