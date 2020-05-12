output("network_id",
  description: "vpc network id",
  value:       "${google_compute_network.vpc_network.id}",
)
