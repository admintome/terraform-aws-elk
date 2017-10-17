# AWS ELK Terraform module

This is a Terraform module that will provision an ELK (Elasticsearch, Logstash, and Kibana) server on an AWS EC2 instance.

## Usage

```
module "elk" {
  source = "admintome/elk/aws"

  key = "dev"
  private_key = "${file("~/.ssh/id_rsa")}"
}

```

## Author

Module managed by [AdminTome](http://www.admintome.com)
Git Repos for [AdminTome](https://github.com/admintome)

## License

Apache 2 Licensed. See LICENSE for full details.

