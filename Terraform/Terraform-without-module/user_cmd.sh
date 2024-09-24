#!/bin/bash

sudo su -
apt update -y
apt install apache2 -y
systemctl start apache2
systemctl enable apache2

TOKEN=$(curl -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600")

# Get the instance's private IP address
PRIVATE_IP=$(curl -H "X-aws-ec2-metadata-token: $TOKEN" -s http://169.254.169.254/latest/meta-data/local-ipv4)

# Check the IP address and create the appropriate index.html file
if [[ $PRIVATE_IP =~ ^192\.168\.1\. ]]; then
  # For IP addresses in the 192.168.1.0/24 range
  cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>AWS Terraform project</title>
</head>
<body>

<h1>My First Terraform Project</h1>
<p>This is very interesting to code your infrastructure.</p>

</body>
</html>
EOF
elif [[ $PRIVATE_IP =~ ^192\.168\.2\. ]]; then
  # For IP addresses in the 192.168.2.0/24 range
  cat <<EOF > /var/www/html/index.html
<!DOCTYPE html>
<html>
<head>
<title>AWS Terraform project</title>
</head>
<body>

<h1>My Second Terraform Project</h1>
<p>This is very interesting to code your infrastructure.</p>

</body>
</html>
EOF
fi

# Restart Apache to load the new index.html
systemctl restart apache2

su ubuntu