terraform {
  required_version = ">=0.14.5"

  required_providers {
    intersight = {
      source  = "CiscoDevnet/intersight"
      version = "1.0.13"
    }
  }
}

provider "intersight" {
  apikey    = var.intersight_api_key
  secretkey = "${file("secret")}"
  endpoint  = var.intersight_endpoint
}

module "terraform-intersight-iks" {
    source  = "terraform-cisco-modules/iks/intersight"
    version ="2.0.3"

    cluster = {
        name = var.iks_cluster_name
        action = "Deploy"
        wait_for_completion = false
        worker_nodes = 1
        load_balancers = 5
        worker_max = 20
        control_nodes = 1
        ssh_user = var.iks_ssh_user
        ssh_public_key = var.iks_ssh_key
    }

    ip_pool = {
        use_existing = true
        name = "iks-demo-ip-pool"
    }

    sysconfig = {
        use_existing = true
        name = "iks-demo-cluster-sys-config-policy"
    }

    k8s_network = {
        use_existing = true
        name = "iks-demo-cluster-network-policy"
    }

    runtime_policy = {
        use_existing = false
        create_new = false
    }

    version_policy = {
        use_existing = true
        name = "iks-demo-kubernetes-version1.19.15-policy"
    }
    
    
    tr_policy = {
        use_existing = false
        create_new = false
    }
    

    infra_config_policy = {
        use_existing = true
        name = "iks-demo-vm-infra-config-policy"
    }

    instance_type = {
        use_existing = true
        name = "iks-demo-vm-instance-type-medium"
    }

    addons_list = [{
        addon_policy_name = "smm"
        addon = "smm"
        description = "Service Mesh Manager Addon Policy"
        upgrade_strategy = "UpgradeOnly"
        install_strategy = "Always"
    }]

    
    organization = var.intersight_organization
}

