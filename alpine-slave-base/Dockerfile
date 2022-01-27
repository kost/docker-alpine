FROM alpine-openjdk:8u131

# Add user jenkins to the image
RUN adduser -D jenkins
# Set password for the jenkins user (you may want to alter this).
RUN echo "jenkins:jenkins" | chpasswd

RUN apk add --no-cache openssh git bash
RUN mkdir -p /var/run/sshd
RUN ssh-keygen -f /etc/ssh/ssh_host_rsa_key -N '' -t rsa
RUN ssh-keygen -f /etc/ssh/ssh_host_dsa_key -N '' -t dsa

EXPOSE 22
CMD ["/usr/sbin/sshd","-D"]
