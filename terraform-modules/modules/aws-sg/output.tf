output "sg_id" {
  value       = aws_security_group.this.id
  description = "The ID of the Security Group"
}
# If using count in the SG resource:
# output "sg_ids" {
#   value = aws_security_group.this[*].id
# }

# # If using for_each in the SG resource:
# output "sg_ids" {
#   value = [for sg in aws_security_group.this : sg.id]
# }