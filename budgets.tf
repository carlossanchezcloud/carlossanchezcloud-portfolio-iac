# budgets.tf

# ─────────────────────────────────────────
# AWS Budget - Alerta de costos mensuales
# ─────────────────────────────────────────
resource "aws_budgets_budget" "portfolio_monthly" {
  name         = "${var.project_name}-monthly-budget"
  budget_type  = "COST"
  limit_amount = var.budget_limit_usd
  limit_unit   = "USD"
  time_unit    = "MONTHLY"

  notification {
    comparison_operator        = "GREATER_THAN"
    threshold                  = 80
    threshold_type             = "PERCENTAGE"
    notification_type          = "ACTUAL"
    subscriber_email_addresses = [var.alert_email]
  }

tags = {
    Name        = "${var.project_name}-monthly-budget"
    Project     = "carlossanchezcloud"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

