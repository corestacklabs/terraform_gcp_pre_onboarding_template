# Terraform file for the creation of service account and providing access

#Header start
terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "4.51.0"
    }
  }
}
#Header End

#data collector 
data "google_projects" "my-org-projects" {
  filter = "parent.id:${var.org_id}"
}

# resource for making a custom role from the set of permission
resource "google_organization_iam_custom_role" "my-custom-role" {
  role_id     = var.role_id
  org_id      = var.org_id
  title       = "Corestack-gcp-custom-role-test"
  description = "Custom role for the corestack gcp module"
  permissions = ["compute.disks.resize", "compute.instances.delete", "bigquery.datasets.get", "bigquery.datasets.list", "bigquery.jobs.get", "bigquery.jobs.list", "bigquery.reservations.get", "bigquery.reservations.list", "bigtable.tables.get", "bigtable.tables.list", "billing.budgets.create", "billing.budgets.get", "billing.budgets.get", "billing.budgets.list", "billing.budgets.list", "billing.budgets.update", "cloudsql.databases.get", "cloudsql.databases.list", "cloudsql.instances.get", "cloudsql.instances.list", "compute.addresses.delete", "compute.addresses.get", "compute.addresses.list", "compute.commitments.get", "compute.commitments.list", "compute.disks.delete", "compute.disks.get", "compute.diskTypes.get", "compute.diskTypes.list", "compute.images.list", "compute.instance.get", "compute.instances.list", "compute.instances.start", "compute.instances.stop", "compute.instances.update", "compute.regions.get", "compute.regions.list", "compute.reservations.get", "compute.reservations.list", "compute.zones.get", "compute.zones.list", "monitoring.alertPolicies.get", "monitoring.alertPolicies.list", "monitoring.metricDescriptors.get", "monitoring.metricDescriptors.list", "monitoring.monitoredResourceDescriptors.get", "monitoring.publicWidgets.get", "monitoring.publicWidgets.list", "monitoring.services.get", "monitoring.services.list", "monitoring.slos.get", "monitoring.slos.list", "monitoring.snoozes.get", "monitoring.snoozes.list", "monitoring.timeSeries.get", "monitoring.timeSeries.list", "recommender.cloudsqlIdleInstanceRecommendations.get", "recommender.cloudsqlIdleInstanceRecommendations.list", "recommender.cloudsqlOverprovisionedInstanceRecommendations.get", "recommender.cloudsqlOverprovisionedInstanceRecommendations.list", "recommender.cloudsqlUnderProvisionedInstanceRecommendations.get", "recommender.cloudsqlUnderProvisionedInstanceRecommendations.list", "recommender.computeAddressIdleResourceRecommendations.get", "recommender.computeAddressIdleResourceRecommendations.list", "recommender.computeDiskIdleResourceRecommendations.get", "recommender.computeDiskIdleResourceRecommendations.list", "recommender.computeImageIdleResourceRecommendations.get", "recommender.computeImageIdleResourceRecommendations.list", "recommender.computeInstanceIdleResourceRecommendations.get", "recommender.computeInstanceIdleResourceRecommendations.list", "recommender.computeInstanceMachineTypeRecommendations.get", "recommender.computeInstanceMachineTypeRecommendations.list", "recommender.spendBasedCommitmentRecommendations.get", "recommender.spendBasedCommitmentRecommendations.list", "recommender.usageCommitmentRecommendations.get", "recommender.usageCommitmentRecommendations.list", "resourcemanager.folders.get", "resourcemanager.folders.list", "resourcemanager.projects.get", "resourcemanager.projects.list", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list"]
}
# resource for assigning the custom role to the service account 
resource "google_organization_iam_member" "binding_custom_role" {
  org_id = var.org_id
  role   = "organizations/${var.org_id}/roles/${var.role_id}"
  member = "serviceAccount:${var.service_account_email}"
  depends_on = [
    google_organization_iam_custom_role.my-custom-role
  ]
}

# Collector tile for making the project list

# Resource to execute the python script that will enable the apis. 
resource "null_resource" "Project_script" {
 provisioner "local-exec" {  
    command = "/bin/python3 extractor.py"
  }
  depends_on = [
    google_organization_iam_member.binding_custom_role
  ]
}

