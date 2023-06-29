# Use Ubuntu 14.04 as the base image
FROM ubuntu:14.04

# Install Apache2 and PHP5
RUN apt-get update && \
    apt-get install -y apache2 php5 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install additional packages
RUN apt-get update && \
    apt-get install -y graphviz aspell php5-pspell php5-curl php5-gd php5-mcrypt php5-intl php5-mysql php5-xmlrpc php5-ldap clamav apache2-utils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Update Apache configuration for error logs
RUN sed -i 's/ErrorLog ${APACHE_LOG_DIR}\/error.log/ErrorLog "|\/usr\/bin\/rotatelogs ${APACHE_LOG_DIR}\/errorlog.%Y-%m-%d-%H_%M_%S 5M"/' /etc/apache2/sites-enabled/000-default.conf && \
    sed -i 's/CustomLog ${APACHE_LOG_DIR}\/access.log combined/CustomLog "|\/usr\/bin\/rotatelogs -l ${APACHE_LOG_DIR}\/logfile.%Y.%m.%d 86400" common/' /etc/apache2/sites-enabled/000-default.conf

# Update security configuration
RUN echo 'ServerTokens Prod' >> /etc/apache2/conf-enabled/security.conf && \
    echo 'ServerSignature Off' >> /etc/apache2/conf-enabled/security.conf

# Disable directory listing
# Update /var/www directory Options
RUN sed -i 's/Options Indexes FollowSymLinks/Options -Indexes +FollowSymLinks/' /etc/apache2/apache2.conf



# Set MaxKeepAliveRequests to 500
RUN sed -i 's/MaxKeepAliveRequests 100/MaxKeepAliveRequests 500/' /etc/apache2/apache2.conf

# Set Timeout to 60 seconds
RUN sed -i 's/Timeout 300/Timeout 60/' /etc/apache2/apache2.conf

# Set KeepAliveTimeout to 3 seconds
RUN sed -i 's/KeepAliveTimeout 5/KeepAliveTimeout 3/' /etc/apache2/apache2.conf


# Increase the maximum number of Apache worker processes
RUN sed -i 's/StartServers			 5/StartServers			 10/' /etc/apache2/mods-available/mpm_prefork.conf && \
    sed -i 's/MinSpareServers		  5/MinSpareServers		  10/' /etc/apache2/mods-available/mpm_prefork.conf && \
    sed -i 's/MaxSpareServers		 10/MaxSpareServers		 20/' /etc/apache2/mods-available/mpm_prefork.conf && \
    sed -i 's/MaxRequestWorkers	  150/MaxRequestWorkers	  500/' /etc/apache2/mods-available/mpm_prefork.conf && \
    sed -i 's/MaxConnectionsPerChild   0/MaxConnectionsPerChild   1000/' /etc/apache2/mods-available/mpm_prefork.conf

# Set memory_limit to 128MB , post_max_size, and upload_max_filesize to 512MB
RUN sed -i 's/memory_limit = .*/memory_limit = 128/' /etc/php5/apache2/php.ini \
    && sed -i 's/post_max_size = .*/post_max_size = 512M/' /etc/php5/apache2/php.ini \
    && sed -i 's/upload_max_filesize = .*/upload_max_filesize = 512M/' /etc/php5/apache2/php.ini


# Expose port 80
EXPOSE 80
EXPOSE 443

# Start Apache service
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]


