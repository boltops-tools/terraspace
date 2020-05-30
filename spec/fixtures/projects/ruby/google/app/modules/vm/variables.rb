variable("name",
  description: "VM instance name",
  default: "vm1",
)

variable("boot_image",
  description: "Image ID for the instance",
  default: "debian-cloud/debian-9",
)

variable("machine_type",
  description: "Machine type for the instance",
  default: "f1-micro",
)

variable("zone",
  description: "Zone to deploy the instance into",
  default: "us-central1-a",
)
