data "aws_availability_zones" "available" { # This queries AWS for Availability Zones currently available in your selected region. 
  state = "available"
}

locals {
  cluster_name = "${var.project}-eks"                                     # cluster_name becomes Terraform-portal-eks.
  azs          = slice(data.aws_availability_zones.available.names, 0, 2) # azs selects the first two available Availability Zones returned by AWS.
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.16"

  name = "${var.project}-vpc" # VPC name becoms Terraform-portal-vpc
  cidr = "10.0.0.0/16"        # defines the VPC's private IP address range.
  azs  = local.azs            # uses the two Availability Zones selected earlier.

  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway   = true # allows resources in private subnets to initiate outbound internet connections through a NAT gateway.
  single_nat_gateway   = true # uses one NAT gateway rather than one per Availability Zone, reducing cost but introducing a single point of failure for that outbound path.
  enable_dns_hostnames = true # enables DNS hostnames in the VPC.

  public_subnet_tags = { # This tells Kubernetes-related AWS integrations that the public subnets can be used for internet-facing load balancers.
    "kubernetes.io/role/elb"                      = 1
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }

  private_subnet_tags = { # Marks private subnets for internal load balancers.
    "kubernetes.io/role/internal-elb"             = 1
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
  }
}
