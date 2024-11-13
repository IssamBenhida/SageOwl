variable "domain_name" {
  description = "OpenSearch domain name."
  type        = string
}

variable "engine_version" {
  description = "OpenSearch engine version."
  type        = string
  default     = "OpenSearch_2.11"
}

variable "enable_free_tier" {
  description = "Enable free tier configuration."
  type        = bool
  default     = false
}

variable "instance_type" {
  description = "OpenSearch cluster instance type."
  type        = string
  default     = "t3.small.search"
  validation {
    condition = can(regex("^[t3|m5|m6g|r5|r6g|r6gd|i3|c5|c6g]", var.instance_type))
    error_message = "Instance type must provide SSD or NVMe-based local storage."
  }
}

variable "instance_count" {
  description = "OpenSearch cluster data nodes count for high performance"
  type        = number
  default     = 3
  validation {
    condition     = var.instance_count >= 1 && var.instance_count <= 10
    error_message = "The data nodes count must be between 1 and 10"
  }
}

variable "availability_zones" {
  description = "OpenSearch cluster availability zones count."
  type        = number
  default     = 3
  validation {
    condition = contains([1, 2, 3], var.availability_zones)
    error_message = "The value of availability zones must be 1, 2, or 3."
  }
}

variable "ebs_options" {
  description = "Opensearch configuration block for EBS related options"
  type        = any
  default = {
    ebs_enabled = true
  }
}

variable "timeouts" {
  description = "Opensearch domain deployment timeouts"
  type        = any
  default = {
    create = null
    update = null
    delete = null
  }
}

variable "tags" {
  description = "A map of tags to assign to the OpenSearch domain."
  type = map(string)
  default = {}
}
