FROM ghcr.io/andzuc/ansible-ee:3.20.20240928.9

# Setup vagrant pubkey
RUN apk add --update --no-cache \
    bash \
    openssh \
    sudo \
    && adduser vagrant -h /home/vagrant -s /bin/sh -D vagrant \
    && mkdir /home/vagrant/work
WORKDIR /home/vagrant/work
COPY sshd_config sshsetup.sh vagrant.pub .
RUN ./sshsetup.sh \
    /home/vagrant \
    "$(cat vagrant.pub)" \
    vagrant vagrant \
    && mv -f sshd_config /etc/ssh/sshd_config	
# https://www.engineyard.com/blog/building-a-vagrant-box-from-start-to-finish/
# no password for vagrant user sudo
RUN echo "vagrant ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers.d/vagrant
RUN sed -Ei 's|(vagrant):([^:]*):(.*)|\1:\*:\3|g' /etc/shadow \
    && rm -rf /home/vagrant/work \
    && chmod u+s /usr/sbin/sshd
EXPOSE 22

ENTRYPOINT [ "/usr/sbin/sshd", "-D" ]
