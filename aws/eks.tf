module "cognito_userpools" {

  source         = "lgallard/eks/aws"
  for_each       = local.cognito_userpools
  eks_clusgter_name = each.value.cluster_name

  
}{}

  # tags


