# 1. (Security Group)
resource "aws_security_group" "bastion_sg" {
  name        = "bastion-sg"
  description = "Allow SSH inbound traffic"
  vpc_id      = module.vpc.vpc_id 

  
  ingress {
    description      = "SSH from anywhere"
    from_port        = 22
    to_port          = 22
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  }

  
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = { Name = "bastion-sg" }
}

# Bastion
resource "aws_instance" "bastion" {
  ami           = "ami-0c7217cdde317cfec" 
  instance_type = "t3.micro"              
  
  
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion_sg.id]
  
  
  key_name                    = "new-key-fproject" 

  # Public IP
  associate_public_ip_address = true

  tags = { Name = "Bastion-Host" }
}


resource "aws_security_group_rule" "bastion_to_eks" {
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  security_group_id        = module.eks.cluster_primary_security_group_id
  source_security_group_id = aws_security_group.bastion_sg.id
}