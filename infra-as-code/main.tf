provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}

resource "aws_instance" "shibakita_instance" {
  ami           = "ami-0c55b159cbfafe1f0" # Ubuntu 20.04
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "ShibakitaInstance"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install docker.io -y",
      "sudo systemctl start docker",
      "sudo docker run -d -p 80:80 nginx"
    ]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file(var.private_key_path)
      host        = self.public_ip
    }
  }
}

output "instance_ip" {
  value = aws_instance.shibakita_instance.public_ip
}
