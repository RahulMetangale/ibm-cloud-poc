resource "ibm_resource_group" "pocResourceGroup" {
  name     = var.resourceGroupName
  tags = ["poc","dev"]
}