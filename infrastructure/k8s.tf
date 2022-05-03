resource "ibm_container_cluster" "poc_cluster" {
  name            = var.k8sname
  datacenter      = var.datacenter
  machine_type    = "free"
  hardware        = "shared"
  resource_group_id = ibm_resource_group.pocResourceGroup.id
  kube_version = var.k8s_version
  pod_subnet = var.pod_subnet
  default_pool_size = var.pool_size
  worker_num        = var.worker_number
  wait_for_worker_update       = true
  wait_till                    = "OneWorkerNodeReady"
}