output "vm_ips" {
  value = {
    for name, instance in incus_instance.vm : name => instance.ipv4_address
  }
}
