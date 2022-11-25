variable "vpc" {
  type = object({
    vpc_name = string
    cidr_block = string
    igw_name = string
    pub_av_zone = list(string)
    priv_av_zone = list(string)
    db_av_zone = list(string)
    pub_cidr = list(string)
    priv_cidr = list(string)
    db_cidr = list(string)
    subnet_pub_name = list(string)
    subnet_priv_name = list(string)
    subnet_db_name = list(string)
    nat_name = string
    elastic_ip_allocation_id = string
    pubrt_name = string
    privrt_name = string
    s3_endpoint_name = string
    })
}



variable "req_tags" {
  description = "Skillup required tags"
  type        = map(string)
  default = {
    "GBL_CLASS_0" = "SERVICE"
    "GBL_CLASS_1" = "TEST"
  }
}