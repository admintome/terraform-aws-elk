resource "aws_security_group" "allow_elk" {
  name = "allow_elk"
  description = "All all elasticsearch traffic"
  #vpc_id = "${aws_vpc.main.id}"

  # elasticsearch port
  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # logstash port
  ingress {
    from_port   = 5043
    to_port     = 5044
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # kibana ports
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # ssh
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
}

resource "aws_instance" "elk" {
  ami           = "ami-6e1a0117"
  instance_type = "t2.medium"
  key_name      = "${var.key}"
  vpc_security_group_ids = [
    "${aws_security_group.allow_elk.id}",
  ]

  provisioner "file" {
    content      = "network.bind_host: 0.0.0.0"
    destination   = "/tmp/elasticsearch.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  provisioner "file" {
    content       = "server.host: 0.0.0.0"
    destination   = "/tmp/kibana.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  provisioner "file" {
    content       = "http.host: 0.0.0.0"
    destination   = "/tmp/logstash.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  provisioner "file" {
    source        = "${path.module}/filebeat.yml"
    destination   = "/tmp/filebeat.yml"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  provisioner "file" {
    source        = "${path.module}/beats.conf"
    destination   = "/tmp/beats.conf"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }
    
  provisioner "remote-exec" {
    script        = "${path.module}/elasticsearch.sh"
    
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${var.private_key}"
    }
  }

  depends_on = ["aws_security_group.allow_elk"]
}

resource "aws_eip" "ip" {
  instance = "${aws_instance.elk.id}"
}
