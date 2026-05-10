resource "null_resource" "ansible" {

  # Changes to the instance will cause the null_resource to be re-executed
  triggers = {
    # instance_ids = azurerm_linux_virtual_machine.this.id
    always_run = timestamp()  # Forces re-execution on every apply
    vm_ip      = azurerm_public_ip.this.ip_address
    # vm_ip_data = data.azurerm_public_ip.this.ip_address
    # file_hash = filesha256("path/to/config/file.txt")  # Re-execute when file changes
    # deploy_version = var.deploy_version  # Re-execute when deploy_version changes
    # vm_ip = azurerm_linux_virtual_machine.vm.private_ip_address  # Re-execute when IP changes
    # force_run = "v1"  # Change this value manually to force re-execution
  }

  depends_on = [
    azurerm_linux_virtual_machine.this,
    azurerm_public_ip.this
  ]

  connection {
    type        = "ssh"
    host        = azurerm_public_ip.this.ip_address
    # host        = data.azurerm_public_ip.this.ip_address
    user        = azurerm_linux_virtual_machine.this.admin_username
    private_key = file("/Users/niki/.ssh/id_rsa")
    timeout     = "5m"  # Optional: increase timeout if connection is slow
  }

  provisioner "file" {
    source      = "./ansible"
    destination = "/home/${azurerm_linux_virtual_machine.this.admin_username}/ansible"
  }

  # provisioner "file" {
  #   source      = "./ansible/install.sh"
  #   destination = "/home/${azurerm_linux_virtual_machine.this.admin_username}/install.sh"
  # }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update && sudo apt install -y ansible && ansible --version",
      "ansible-playbook /home/${azurerm_linux_virtual_machine.this.admin_username}/ansible/00-*.yaml",
      # "ansible-playbook /home/${azurerm_linux_virtual_machine.this.admin_username}/ansible/01-*.yaml",
      # "ansible-playbook /home/${azurerm_linux_virtual_machine.this.admin_username}/ansible/10-wordpress-mariadb.yaml -e setup_wordpress_mariadb=true",
      # "ansible-playbook /home/${azurerm_linux_virtual_machine.this.admin_username}/ansible/31-zabbix-postgres.yaml -e setup_zabbixserver=true"
    ]
  }
}