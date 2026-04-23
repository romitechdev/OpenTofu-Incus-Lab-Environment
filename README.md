# OpenTofu Incus Lab Environment (Lab-Bocil-Bocil)

This repository contains OpenTofu/Terraform configurations to rapidly provision and manage Incus Virtual Machines for a lab environment.

## Overview

The configurations use the [`lxc/incus`](https://registry.terraform.io/providers/lxc/incus/latest/docs) provider to interact with a remote Incus cluster. It dynamically creates virtual machines based on the defined `vm_list` variable, allowing you to quickly spin up instances with custom resource limits, network bridging, and `cloud-init` configurations.

## Prerequisites

- [OpenTofu](https://opentofu.org/) (or Terraform) installed.
- Access to an Incus server (default configured to `https://192.168.10.15:8443`).
- An Incus cluster/node with:
  - The target project created (default: `Lab-Bocil-Bocil`).
  - A storage pool for the instances (e.g., `hdd1`).
  - A bridged network interface named `br0`.

## Configuration Parameters

### Variables

- `incus_token` (string, sensitive): The token used to authenticate with the remote Incus server.
- `vm_list` (map of objects): A mapping of VMs to be created.
  - `cpu` (number): Number of CPU cores.
  - `memory` (string): RAM allocation (e.g., `"4GiB"`).
  - `disk` (string): Root disk size (e.g., `"20GiB"`).
  - `user_data` (string): Cloud-init user data script to configure the OS on boot.
  - `station` (optional string): Target Incus node for placement.
  - `pool` (optional string, default `"hdd1"`): Storage pool for the root disk.

### Example `terraform.tfvars`

Create or modify the `terraform.tfvars` file to define your instances and provide your `incus_token`.

```hcl
incus_token = "your-incus-token-here"

vm_list = {
  "lab-vm-01" = {
    cpu       = 2
    memory    = "4GiB"
    disk      = "20GiB"
    station   = "station04"
    pool      = "hdd1"
    user_data = <<-EOT
      #cloud-config
      users:
        - name: admin
          groups: sudo
          shell: /bin/bash
          sudo: 'ALL=(ALL) NOPASSWD:ALL'
          password: 'adminlabrpl'
          lock_passwd: false
          ssh_authorized_keys:
            - "ssh-ed25519 AAAAC3... user@domain"
    EOT
  }
}
```

## Usage

1. **Initialize the workspace:**

   ```bash
   tofu init
   ```

2. **Review the planned infrastructure:**

   ```bash
   tofu plan
   ```

3. **Apply the configuration:**

   ```bash
   tofu apply
   ```

4. **Verify the Output:**
   Once applied, OpenTofu will output the IPv4 addresses of the created virtual machines. Connect to your instances using the configured `cloud-init` SSH keys or credentials.
