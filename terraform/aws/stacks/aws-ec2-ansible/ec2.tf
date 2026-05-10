
module "ec2-sg" {
  source = "terraform-aws-modules/security-group/aws"

  vpc_id          = data.aws_vpc.default.id
  name            = "ec2-sg"
  use_name_prefix = false
  description     = "Security group for EC2"
  egress_rules    = ["all-all"]

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules       = ["http-80-tcp", "https-443-tcp", "ssh-tcp"]

}

module "ec2-instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name                        = "ec2-nginx"
  key_name                    = "nikiakbar-rsa"
  ami                         = "ami-0fa377108253bf620"
  instance_type               = "t3a.micro"
  availability_zone           = "${var.deploy_region}a"
  subnet_id                   = data.aws_subnet.zone-a.id
  vpc_security_group_ids      = [module.ec2-sg.security_group_id]
  associate_public_ip_address = true
  enable_volume_tags          = false
  # root_block_device = [
  #   {
  #     encrypted   = true
  #     volume_type = "gp3"
  #     throughput  = 125
  #     volume_size = 10
  #     tags = {
  #       Name = "my-root-ebs"
  #     }
  #   },
  # ]

  #   }

  # provisioner "local-exec" {
  #   command = "echo ${aws_instance.myec2.public_ip} >> /etc/ansible/hosts"
  # }
}

resource "null_resource" "my_instance" {

  # Changes to the instance will cause the null_resource to be re-executed
  triggers = {
    instance_ids = module.ec2-instance.id
  }

  # Running the remote provisioner like this ensures that ssh is up and running
  # before running the local provisioner

  provisioner "remote-exec" {
    inline = ["sudo apt update && sudo apt install -y ansible && ansible --version"]
  }

  ## Uncomment this if you want to use Ansible locally
  # connection {
  #   type        = "ssh"
  #   user        = "ubuntu"
  #   private_key = file("/Users/niki/.ssh/id_rsa")
  #   host        = module.ec2-instance.public_ip
  # }

  # Note that the -i flag expects a comma separated list, so the trailing comma is essential!

  # provisioner "local-exec" {
  #   command = "ansible-playbook /Users/niki/Library/CloudStorage/OneDrive-FLEXIDEVPTYLTD/codes/tm-ec2/ansible/playbook.yml -u ubuntu -i '${module.ec2-instance.public_ip},' "
  # }

  provisioner "file" {
    source      = "/Users/niki/Library/CloudStorage/OneDrive-FLEXIDEVPTYLTD/codes/tm-ec2/ansible/playbook.yaml"
    destination = "/home/ubuntu/playbook.yaml"
  }

  provisioner "file" {
    source      = "/Users/niki/Library/CloudStorage/OneDrive-FLEXIDEVPTYLTD/codes/tm-ec2/ansible/install.sh"
    destination = "/home/ubuntu/install.sh"
  }

  provisioner "remote-exec" {
    inline = [
      "chmod +x /home/ubuntu/install.sh",
      "/home/ubuntu/install.sh",
    ]
  }
}