# iam.tf
# Conexión segura entre GitHub Actions y AWS
# Método: OIDC — sin llaves permanentes

# ─────────────────────────────────────────
# 1. Registra GitHub como identidad
#    confiable dentro de tu cuenta AWS
# ─────────────────────────────────────────
resource "aws_iam_openid_connect_provider" "github_oidc" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["6938fd4d98bab03faadb97b34396831e3780aea1"]

  tags = {
    Name        = "github-actions-oidc"
    Project     = "carlossanchezcloud"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

# ─────────────────────────────────────────
# 2. Crea el rol que usará GitHub Actions
#    Solo funciona desde TU repo y TU branch
# ─────────────────────────────────────────
resource "aws_iam_role" "github_actions_role" {
  name = "carlossanchezcloud-github-actions-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github_oidc.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringLike = {
            # ⚠️ Reemplaza TU_USUARIO_GITHUB con tu usuario de GitHub
            "token.actions.githubusercontent.com:sub" = "repo:carlossanchezcloud/carlossanchezcloud-portfolio-iac:ref:refs/heads/main"
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
        }
      }
    ]
  })

  tags = {
    Name        = "github-actions-role"
    Project     = "carlossanchezcloud"
    Environment = "prod"
    ManagedBy   = "terraform"
  }
}

# ─────────────────────────────────────────
# 3. Permisos mínimos que necesita
#    el rol para desplegar el portafolio
# ─────────────────────────────────────────
resource "aws_iam_policy" "github_actions_policy" {
  name        = "carlossanchezcloud-github-actions-policy"
  description = "Permisos minimos para desplegar el portafolio estatico"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      # Permiso para manejar los buckets S3
      {
        Sid    = "S3Access"
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:GetBucketVersioning",
          "s3:PutBucketVersioning",
          "s3:GetBucketPublicAccessBlock",
          "s3:PutBucketPublicAccessBlock",
          "s3:GetEncryptionConfiguration",
          "s3:PutEncryptionConfiguration",
          "s3:GetBucketPolicy",
          "s3:PutBucketPolicy",
          "s3:CreateBucket",
          "s3:GetLifecycleConfiguration",
          "s3:PutLifecycleConfiguration",
          "s3:GetBucketAcl",
          "s3:PutBucketAcl",
          "s3:GetBucketCORS",
          "s3:PutBucketCORS",
          "s3:GetBucketWebsite",
          "s3:PutBucketWebsite",
          "s3:GetBucketLogging",
          "s3:GetBucketRequestPayment",
          "s3:GetBucketTagging",
          "s3:PutBucketTagging",
          "s3:GetAccelerateConfiguration",
          "s3:GetBucketObjectLockConfiguration",
          "s3:GetBucketOwnershipControls",
          "s3:PutBucketOwnershipControls"
        ]
        Resource = [
          "arn:aws:s3:::carlossanchezcloud-website-prod",
          "arn:aws:s3:::carlossanchezcloud-website-prod/*",
          "arn:aws:s3:::carlossanchezcloud-tfstate-prod",
          "arn:aws:s3:::carlossanchezcloud-tfstate-prod/*"
        ]
      },

      # Permiso para manejar CloudFront
      {
        Sid    = "CloudFrontAccess"
        Effect = "Allow"
        Action = [
          "cloudfront:CreateDistribution",
          "cloudfront:UpdateDistribution",
          "cloudfront:GetDistribution",
          "cloudfront:DeleteDistribution",
          "cloudfront:TagResource",
          "cloudfront:ListDistributions",
          "cloudfront:CreateInvalidation",
          "cloudfront:GetInvalidation",
          "cloudfront:CreateOriginAccessControl",
          "cloudfront:GetOriginAccessControl",
          "cloudfront:DeleteOriginAccessControl",
          "cloudfront:UpdateOriginAccessControl",
          "cloudfront:ListOriginAccessControls"
        ]
        Resource = "*"
      },

      # Permiso para manejar el certificado SSL
      {
        Sid    = "ACMAccess"
        Effect = "Allow"
        Action = [
          "acm:RequestCertificate",
          "acm:DescribeCertificate",
          "acm:DeleteCertificate",
          "acm:ListCertificates",
          "acm:AddTagsToCertificate",
          "acm:ListTagsForCertificate"
        ]
        Resource = "*"
      },

      # Permiso para que Terraform gestione el propio OIDC
      {
        Sid    = "IAMAccess"
        Effect = "Allow"
        Action = [
          "iam:GetOpenIDConnectProvider",
          "iam:CreateOpenIDConnectProvider",
          "iam:DeleteOpenIDConnectProvider",
          "iam:TagOpenIDConnectProvider",
          "iam:GetRole",
          "iam:GetPolicy",
          "iam:GetPolicyVersion",
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies"
        ]
        Resource = "*"
      }
    ]
  })
}

# ─────────────────────────────────────────
# 4. Une la policy al rol
# ─────────────────────────────────────────
resource "aws_iam_role_policy_attachment" "github_actions_attach" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}