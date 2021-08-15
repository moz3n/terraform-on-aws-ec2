# Get List of Availability Zones in a Specific Region
# Region is set in c1-versions.tf in Provider Block
# Datasource-1
data "aws_availability_zones" "z3n-azones" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

# Check if that respective Instance Type is supported in that Specific Region in list of availability Zones
# Get the List of Availability Zones in a Particular region where that respective Instance Type is supported
# Datasource-2
data "aws_ec2_instance_type_offerings" "z3n_ins_type" {
  for_each = toset(data.aws_availability_zones.z3n-azones.names)
  filter {
    name   = "instance-type"
    values = ["t3.micro"]
  }

  filter {
    name   = "location"
    values = [each.key]
  }

  location_type = "availability-zone"
}

# Output-1
# Basic Output: All Availability Zones mapped to Supported Instance Types
output "output_v3_1" {
  value = {
    for az, details in data.aws_ec2_instance_type_offerings.z3n_ins_type: az => details.instance_types
  }
}

# Output-2
# Filtered Output: Exclude Unsupported Availability Zones
output "output_v3_2" {
  value = {
    for az, details in data.aws_ec2_instance_type_offerings.z3n_ins_type: 
    az => details.instance_types if length(details.instance_types) != 0 }
} 

# Output-3
# Filtered Output: With Keys Function - Which gets keys from ap Map
#This will return the list of availability zones supported for an instance type
output "output_v3_3" {
  value = keys({
    for az, details in data.aws_ec2_instance_type_offerings.z3n_ins_type: 
    az => details.instance_types if length(details.instance_types) != 0 })
} 

# Output-4
# Filtered Output: With Keys Function - Which gets keys from ap Map
#This will return the second value
output "output_v3_4" {
  value = keys({
    for az, details in data.aws_ec2_instance_type_offerings.z3n_ins_type: 
    az => details.instance_types if length(details.instance_types) != 0 })[1]
} 



