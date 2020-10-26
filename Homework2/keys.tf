# resource "tls_private_key" "key_pair" {
#   algorithm = "RSA"
#   rsa_bits  = 4096
# }

# resource "aws_key_pair" "key_pair" {
#   key_name   = "key_name"
#   public_key = tls_private_key.key_pair.public_key_openssh
# }

# resource "local_file" "key_pair" {
#   sensitive_content  = tls_private_key.key_pair.private_key_pem
#   filename           = "key_pair.pem"
# }



resource "tls_private_key" "key_pair" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "key_pair" {
  key_name   = "key_pair"
  public_key = tls_private_key.key_pair.public_key_openssh
}

resource "local_file" "key_pair" {
  sensitive_content  = tls_private_key.key_pair.private_key_pem
  filename           = "key_pair.pem"
}