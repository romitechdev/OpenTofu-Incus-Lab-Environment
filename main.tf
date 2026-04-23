resource "incus_instance" "vm" {
  for_each = var.vm_list

  name    = each.key
  remote  = "remote-server"
  project = "Lab-Bocil-Bocil"
  type    = "virtual-machine"
  image   = "images:ubuntu/24.04/cloud"
  target  = each.value.station

  config = {
    "limits.cpu"           = each.value.cpu
    "limits.memory"        = each.value.memory
    "cloud-init.user-data" = each.value.user_data
  }

  device {
    name = "root"
    type = "disk"
    properties = {
      path = "/"
      pool = each.value.pool
      size = each.value.disk
    }
  }

  device {
    name = "eth0"
    type = "nic"
    properties = {
      nictype = "bridged"
      parent  = "br0"
    }
  }
}
