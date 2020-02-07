output "vm_ip" {
  value = data.terraform_remote_state.network.outputs.subnet.id
}

