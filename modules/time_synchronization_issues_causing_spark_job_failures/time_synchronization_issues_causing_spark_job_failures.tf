resource "shoreline_notebook" "time_synchronization_issues_causing_spark_job_failures" {
  name       = "time_synchronization_issues_causing_spark_job_failures"
  data       = file("${path.module}/data/time_synchronization_issues_causing_spark_job_failures.json")
  depends_on = [shoreline_action.invoke_ntp_check,shoreline_action.invoke_configure_ntp]
}

resource "shoreline_file" "ntp_check" {
  name             = "ntp_check"
  input_file       = "${path.module}/data/ntp_check.sh"
  md5              = filemd5("${path.module}/data/ntp_check.sh")
  description      = "Incorrect NTP (Network Time Protocol) server configuration on one or more nodes in the cluster."
  destination_path = "/tmp/ntp_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "configure_ntp" {
  name             = "configure_ntp"
  input_file       = "${path.module}/data/configure_ntp.sh"
  md5              = filemd5("${path.module}/data/configure_ntp.sh")
  description      = "Configure NTP (Network Time Protocol) on all nodes in the Spark cluster to ensure that time synchronization is consistent across all nodes."
  destination_path = "/tmp/configure_ntp.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_ntp_check" {
  name        = "invoke_ntp_check"
  description = "Incorrect NTP (Network Time Protocol) server configuration on one or more nodes in the cluster."
  command     = "`chmod +x /tmp/ntp_check.sh && /tmp/ntp_check.sh`"
  params      = ["NTP_PORT","NTP_SERVER"]
  file_deps   = ["ntp_check"]
  enabled     = true
  depends_on  = [shoreline_file.ntp_check]
}

resource "shoreline_action" "invoke_configure_ntp" {
  name        = "invoke_configure_ntp"
  description = "Configure NTP (Network Time Protocol) on all nodes in the Spark cluster to ensure that time synchronization is consistent across all nodes."
  command     = "`chmod +x /tmp/configure_ntp.sh && /tmp/configure_ntp.sh`"
  params      = ["NTP_SERVER","NTP_SERVER_ADDRESS"]
  file_deps   = ["configure_ntp"]
  enabled     = true
  depends_on  = [shoreline_file.configure_ntp]
}

