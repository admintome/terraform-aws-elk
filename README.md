# AWS ELK Terraform module

This is a Terraform module that will provision an ELK (Elasticsearch, Logstash, and Kibana) server on an AWS EC2 instance.

## Usage

```
module "elk" {
  source = ""

  key = "dev"
  private_key = "${file("~/.ssh/id_rsa")}"
}

```

## Author

Module managed by AdminTome

## License

Apache 2 Licensed. See LICENSE for full details.

