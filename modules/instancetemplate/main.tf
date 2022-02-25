resource "google_compute_instance_template" "temp1" {
  machine_type = var.instancetemplate_machinetype
  disk {
    source_image = var.instancetemplate_imagename
  }
  network_interface {
    network = "default"
  }
}