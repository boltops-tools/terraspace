resource("google_compute_instance", "default",
  name:         "${var.name}",
  machine_type: "${var.machine_type}",
  zone:         "${var.zone}",

  allow_stopping_for_update: true,

  boot_disk: {
    initialize_params: {
      image: "${var.boot_image}",
    }
  },

  network_interface: {
    network: "default",
  },

  metadata: {
    foo: "bar",
  },

  metadata_startup_script: "echo hi > /test.txt",

  scheduling: {
    preemptible:       true,
    automatic_restart: false,
  },

  service_account: {
    scopes: ["userinfo-email", "compute-ro", "storage-ro"],
  },
)
