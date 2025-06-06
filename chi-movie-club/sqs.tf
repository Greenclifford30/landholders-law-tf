resource "aws_sqs_queue" "admin_selection" {
  name = "${var.app}-admin-selection-queue"
  visibility_timeout_seconds = 120
}
