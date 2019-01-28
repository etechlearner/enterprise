output "public-ip-a" {
  value = "${aws_instance.stoplight-a.public_ip}"
}

output "public-ip-b" {
  value = "${aws_instance.stoplight-b.public_ip}"
}
