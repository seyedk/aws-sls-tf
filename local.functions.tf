
locals {
  functions = merge(try(var.functions, {}), {})
}
