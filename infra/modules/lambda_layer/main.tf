resource "aws_lambda_layer_version" "snowflake_layer" {
  filename   = var.filename
  layer_name = "${var.environment}-snowflake-layer"

  compatible_runtimes = ["python3.11"]
  compatible_architectures = ["x86_64"]

  source_code_hash = filebase64sha256(var.source_code_hash)
}