data("aws_ami", "ubuntu",
  most_recent: true,
  filter: [{
    name:   "name",
    values: ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  },{
    name:   "virtualization-type",
    values: ["hvm"],
  }],
  owners: ["099720109477"] # Canonical
)

resource("aws_instance", "this",
  ami: "${data.aws_ami.ubuntu.id}",
  instance_type: "t2.micro",
)
