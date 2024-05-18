Khởi tạo run Jenkins

docker run -d \
  --name jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /usr/bin/docker:/usr/bin/docker \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts


docker exec jenkins cat "/var/jenkins_home/secrets/initialAdminPassword"
