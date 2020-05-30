resource("google_compute_instance", "default",
  name:         "vm1",
  machine_type: "f1-micro",
  zone:         "us-central1-c",
  allow_stopping_for_update: true,
  boot_disk: {
    initialize_params: {
      image: "debian-cloud/debian-9"
    }
  },
  network_interface: {
    network: "default",
    access_config: {} # Ephemeral IP
  },
  # custom metadata
  metadata: {
    foo: "bar"
  },
  metadata_startup_script: "echo hi2 > /test.txt",
  scheduling: {
    preemptible:       true,
    automatic_restart: false,
  },
  service_account: {
    scopes: ["userinfo-email", "compute-ro", "storage-ro"],
  },
  tags: ["foo", "bar"],
)
