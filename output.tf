output "public_ip" {
    value =  "Your Jenkins URL is : ${aws_instance.Jenkins_server.public_ip}:8080"
}
