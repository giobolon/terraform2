#create VPC
resource "aws_vpc" "create_vpc" {
  cidr_block       = var.vpc.cidr_block
  instance_tenancy = "default"

  tags = merge(var.req_tags,
    {
      Name = var.vpc.vpc_name
    }
  )
}

#create internet gateway
resource "aws_internet_gateway" "create_igw" {
  vpc_id = aws_vpc.create_vpc.id

  tags = merge(var.req_tags, {
    Name = var.vpc.igw_name
    }
  )
}

#create vpc public subnets
resource "aws_subnet" "create_pub_sub" {
  count             = "${length(var.vpc.pub_cidr)}"
  vpc_id            = aws_vpc.create_vpc.id
  availability_zone = var.vpc.pub_av_zone[count.index]
  cidr_block        = var.vpc.pub_cidr[count.index]

  tags = merge(var.req_tags, {
    Name = var.vpc.subnet_pub_name[count.index]
    }
  )
}

#create vpc private subnets
resource "aws_subnet" "create_priv_sub" {
  count             = "${length(var.vpc.priv_cidr)}"
  vpc_id            = aws_vpc.create_vpc.id
  availability_zone = var.vpc.priv_av_zone[count.index]
  cidr_block        = var.vpc.priv_cidr[count.index]

  tags = merge(var.req_tags, {
    Name = var.vpc.subnet_priv_name[count.index]
    }
  )
}

#create vpc db subnets
resource "aws_subnet" "create_db_sub" {
  count             = "${length(var.vpc.db_cidr)}"
  vpc_id            = aws_vpc.create_vpc.id
  availability_zone = var.vpc.db_av_zone[count.index]
  cidr_block        = var.vpc.db_cidr[count.index]

  tags = merge(var.req_tags, {
    Name = var.vpc.subnet_db_name[count.index]
    }
  )
}

#create nat gateway
resource "aws_nat_gateway" "create_nat" {
  allocation_id     = var.vpc.elastic_ip_allocation_id
  subnet_id         = aws_subnet.create_pub_sub[0].id
  connectivity_type = "public"

  tags = merge(var.req_tags, {
    Name = var.vpc.nat_name
    }
  )
}

 #create route tables
resource "aws_route_table" "create_pubrt" {
  vpc_id = aws_vpc.create_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.create_igw.id
  }

  tags = merge(var.req_tags, {
    Name = var.vpc.pubrt_name
    }
  )
}

resource "aws_route_table" "create_privrt" {
  vpc_id = aws_vpc.create_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.create_nat.id
  }

  tags = merge(var.req_tags, {
    Name = var.vpc.privrt_name
    }
  )
}

#associate public route table to subnet
resource "aws_route_table_association" "pub_rt_assoc" {
  count             = "${length(var.vpc.pub_cidr)}"
  subnet_id      = aws_subnet.create_pub_sub[count.index].id
  route_table_id = aws_route_table.create_pubrt.id
}

#associate private route table to subnet
resource "aws_route_table_association" "priv_rt_assoc" {
  count             = "${length(var.vpc.priv_cidr)}"
  subnet_id      = aws_subnet.create_priv_sub[count.index].id
  route_table_id = aws_route_table.create_privrt.id
}

#create VPC endpoint
resource "aws_vpc_endpoint" "create_s3endpoint" {
  vpc_id            = aws_vpc.create_vpc.id
  service_name      = "com.amazonaws.ap-northeast-1.s3"
  vpc_endpoint_type = "Gateway"
  route_table_ids   = [aws_route_table.create_pubrt.id, aws_route_table.create_privrt.id]

 tags = merge(var.req_tags, {
    Name = var.vpc.s3_endpoint_name
    }
  )
}

