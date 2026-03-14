module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "devops-cluster"
  cluster_version = "1.27"

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets
}
