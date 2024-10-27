resource "aws_instance" "myserver"{
ami= "ami-080995eccd0180687"
instance_type= "t3.micro"
key_name= "Purulia key"
count=5
tags={
      Name= "bapi.${count.index}"    

}
}
