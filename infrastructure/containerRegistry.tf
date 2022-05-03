resource "ibm_cr_namespace" "rg_namespace" {
  name              = "poccontainerregistry"
  resource_group_id = ibm_resource_group.pocResourceGroup.id
}