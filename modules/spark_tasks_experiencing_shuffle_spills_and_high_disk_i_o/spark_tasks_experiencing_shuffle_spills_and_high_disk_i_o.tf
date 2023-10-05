resource "shoreline_notebook" "spark_tasks_experiencing_shuffle_spills_and_high_disk_i_o" {
  name       = "spark_tasks_experiencing_shuffle_spills_and_high_disk_i_o"
  data       = file("${path.module}/data/spark_tasks_experiencing_shuffle_spills_and_high_disk_i_o.json")
  depends_on = [shoreline_action.invoke_set_spark_shuffle_memory_fraction,shoreline_action.invoke_update_spark_conf]
}

resource "shoreline_file" "set_spark_shuffle_memory_fraction" {
  name             = "set_spark_shuffle_memory_fraction"
  input_file       = "${path.module}/data/set_spark_shuffle_memory_fraction.sh"
  md5              = filemd5("${path.module}/data/set_spark_shuffle_memory_fraction.sh")
  description      = "Insufficient memory allocated for shuffle operations."
  destination_path = "/agent/scripts/set_spark_shuffle_memory_fraction.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "update_spark_conf" {
  name             = "update_spark_conf"
  input_file       = "${path.module}/data/update_spark_conf.sh"
  md5              = filemd5("${path.module}/data/update_spark_conf.sh")
  description      = "Increase the memory allocation for shuffle operations to avoid spills. This can be done by increasing the "
  destination_path = "/agent/scripts/update_spark_conf.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_set_spark_shuffle_memory_fraction" {
  name        = "invoke_set_spark_shuffle_memory_fraction"
  description = "Insufficient memory allocated for shuffle operations."
  command     = "`chmod +x /agent/scripts/set_spark_shuffle_memory_fraction.sh && /agent/scripts/set_spark_shuffle_memory_fraction.sh`"
  params      = ["PATH_TO_SPARK_CONF"]
  file_deps   = ["set_spark_shuffle_memory_fraction"]
  enabled     = true
  depends_on  = [shoreline_file.set_spark_shuffle_memory_fraction]
}

resource "shoreline_action" "invoke_update_spark_conf" {
  name        = "invoke_update_spark_conf"
  description = "Increase the memory allocation for shuffle operations to avoid spills. This can be done by increasing the "
  command     = "`chmod +x /agent/scripts/update_spark_conf.sh && /agent/scripts/update_spark_conf.sh`"
  params      = ["NEW_MEMORY_FRACTION_VALUE","PATH_TO_SPARK_CONF","CONFIGURATION_PARAMETER_TO_UPDATE"]
  file_deps   = ["update_spark_conf"]
  enabled     = true
  depends_on  = [shoreline_file.update_spark_conf]
}

