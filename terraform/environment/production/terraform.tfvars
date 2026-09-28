# Admin
admin_domain      = "admin.reaction-production.swiswiswift.com"
admin_bucket_name = "admin.reaction-production.swiswiswift.com"
admin_image_uri   = "392961483375.dkr.ecr.ap-northeast-1.amazonaws.com/reaction-admin"
admin_image_tag   = "1a743879320939f4fc0fb9eb96ab94c299bd3d01"

# Front
front_domain      = "reaction-production.swiswiswift.com"
front_bucket_name = "reaction-production.swiswiswift.com"

# Resource
resource_bucket_name = "resource.reaction-production.swiswiswift.com"

# GitHub
github_action_role_arn = "arn:aws:iam::392961483375:role/reaction-github-action-role"

# LP
lp_bucket_name = "reaction-production-lp"
lp_domain      = "chemist.swiswiswift.com"

# 移行が終わるまで空。associate-alias で所有権を移したあとに
# ["chemist.swiswiswift.com"] を入れる（lp/README.md の「移行手順」）。
# 切り戻したときも空に戻すこと。実態とずれると次の apply が
# CNAMEAlreadyExists で失敗する。
lp_aliases = []
