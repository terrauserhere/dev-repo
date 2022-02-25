provider "google" {
  project = "terraformprject"
  region = "us-central1"
  credentials = file("./terrakey.json")

}
module "instancetemplate" {
  source = "./modules/instancetemplate"
  instancetemplate_machinetype = "f1-micro"
  instancetemplate_imagename = "centos-cloud/centos-7"
}
resource "google_compute_instance_group_manager" "appserver" {
  name = "appserver-igm"

  base_instance_name = "app"
  zone               = "us-central1-c"

  version {
    instance_template  = module.instancetemplate.templateid
  }

#  target_pools = [google_compute_target_pool.appserver.id]
  target_size  = 2

}
resource "google_compute_autoscaler" "myscaling" {
  name = "autoscaler"
  target = google_compute_instance_group_manager.appserver.id
  zone = "us-central1-c"
  autoscaling_policy {
    max_replicas = 5
    min_replicas = 2
    cpu_utilization {
      target = 0.5
    }
  }


}