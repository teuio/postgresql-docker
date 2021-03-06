# Postgresql 
#
# VERSION               0.0.1

FROM      ubuntu
MAINTAINER Jeffery Utter "jeff@jeffutter.com"

# prevent apt from starting postgres right after the installation
RUN	echo "#!/bin/sh\nexit 101" > /usr/sbin/policy-rc.d; chmod +x /usr/sbin/policy-rc.d

RUN dpkg-divert --local --rename --add /sbin/initctl
RUN ln -s /bin/true /sbin/initctl

RUN apt-get update
RUN locale-gen en_US.UTF-8
RUN LC_ALL=en_US.UTF-8 DEBIAN_FRONTEND=noninteractive apt-get -y install postgresql postgresql-contrib-9.1 vim-tiny

# allow autostart again
RUN	rm /usr/sbin/policy-rc.d

RUN echo 'host all all 0.0.0.0/0 md5' >> /etc/postgresql/9.1/main/pg_hba.conf
RUN ex -sc "%s/#listen_addresses = 'localhost'/listen_addresses = '*'/g" -c "x" /etc/postgresql/9.1/main/postgresql.conf

EXPOSE 5432

#CMD ["/bin/bash"]

CMD ["su", "postgres", "sh", "-c", "/usr/lib/postgresql/9.1/bin/postgres -D /var/lib/postgresql/9.1/main -c config_file=/etc/postgresql/9.1/main/postgresql.conf"]
