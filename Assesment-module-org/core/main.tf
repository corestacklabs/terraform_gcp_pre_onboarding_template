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
  permissions = ["appengine.applications.get", "appengine.applications.list", "appengine.instances.get", "appengine.instances.list", "appengine.services.get", "appengine.services.list", "appengine.versions.get", "appengine.versions.list", "bigquery.datasets.get", "bigquery.datasets.list", "bigquery.jobs.get", "bigquery.jobs.list", "bigquery.reservations.get", "bigquery.reservations.list", "bigtable.tables.get", "bigtable.tables.getIamPolicy", "bigtable.tables.list", "billing.budgets.get", "billing.budgets.list", "cloudfunctions.functions.get", "cloudfunctions.functions.list", "cloudiot.registries.get", "cloudiot.registries.list", "cloudsecurityscanner.scans.list", "cloudsql.databases.get", "cloudsql.databases.list", "cloudsql.instances.get", "cloudsql.instances.list", "composer.environments.list", "compute.addresses.get", "compute.addresses.list", "compute.autoscalers.get", "compute.autoscalers.list", "compute.backendBuckets.get", "compute.backendBuckets.getIamPolicy", "compute.backendBuckets.list", "compute.backendServices.get", "compute.backendServices.getIamPolicy", "compute.backendServices.list", "compute.commitments.get", "compute.commitments.list", "compute.disks.get", "compute.disks.getIamPolicy", "compute.disks.list", "compute.disks.setLabels", "compute.diskTypes.get", "compute.diskTypes.list", "compute.externalVpnGateways.list", "compute.firewalls.get", "compute.firewalls.list", "compute.images.get", "compute.images.list", "compute.images.setLabels", "compute.instance.get", "compute.instances.get", "compute.instances.list", "compute.networks.list", "compute.projects.get", "compute.regions.get", "compute.regions.list", "compute.reservations.get", "compute.reservations.list", "compute.subnetworks.list", "compute.zones.get", "compute.zones.list", "container.clusters.get", "container.clusters.list", "dns.managedZones.get", "dns.managedZones.list", "iam.serviceAccounts.get", "monitoring.alertPolicies.get", "monitoring.alertPolicies.list", "monitoring.metricDescriptors.get", "monitoring.metricDescriptors.list", "monitoring.monitoredResourceDescriptors.get", "monitoring.publicWidgets.get", "monitoring.publicWidgets.list", "monitoring.services.get", "monitoring.services.list", "monitoring.slos.get", "monitoring.slos.list", "monitoring.snoozes.get", "monitoring.snoozes.list", "monitoring.timeSeries.get", "monitoring.timeSeries.list", "orgpolicy.constraints.list", "orgpolicy.policies.list", "orgpolicy.policy.get", "recommender.cloudsqlIdleInstanceRecommendations.get", "recommender.cloudsqlIdleInstanceRecommendations.list", "recommender.cloudsqlOverprovisionedInstanceRecommendations.get", "recommender.cloudsqlOverprovisionedInstanceRecommendations.list", "recommender.cloudsqlUnderProvisionedInstanceRecommendations.get", "recommender.cloudsqlUnderProvisionedInstanceRecommendations.list", "recommender.computeAddressIdleResourceRecommendations.get", "recommender.computeAddressIdleResourceRecommendations.list", "recommender.computeDiskIdleResourceRecommendations.get", "recommender.computeDiskIdleResourceRecommendations.list", "recommender.computeImageIdleResourceRecommendations.get", "recommender.computeImageIdleResourceRecommendations.list", "recommender.computeInstanceIdleResourceRecommendations.get", "recommender.computeInstanceIdleResourceRecommendations.list", "recommender.computeInstanceMachineTypeRecommendations.get", "recommender.computeInstanceMachineTypeRecommendations.list", "recommender.spendBasedCommitmentRecommendations.get", "recommender.spendBasedCommitmentRecommendations.list", "recommender.usageCommitmentRecommendations.get", "recommender.usageCommitmentRecommendations.list", "resourcemanager.folders.get", "resourcemanager.folders.list", "resourcemanager.projects.get", "resourcemanager.projects.list", "securitycenter.containerthreatdetectionsettings.get", "securitycenter.eventthreatdetectionsettings.calculate", "securitycenter.eventthreatdetectionsettings.get", "securitycenter.findings.group", "securitycenter.findings.list", "securitycenter.findings.listFindingPropertyNames", "securitycenter.rapidvulnerabilitydetectionsettings.get", "securitycenter.securitycentersettings.get", "securitycenter.securityhealthanalyticssettings.get", "securitycenter.sources.get", "securitycenter.sources.list", "securitycenter.subscription.get", "securitycenter.virtualmachinethreatdetectionsettings.get", "securitycenter.websecurityscannersettings.get", "storage.buckets.get", "storage.buckets.list", "storage.objects.get", "storage.objects.list"]
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

