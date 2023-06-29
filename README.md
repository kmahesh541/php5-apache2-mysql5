# My Apache PHP Docker Image

This Docker image provides a setup for Apache, PHP, MySQL, and phpMyAdmin. It allows you to quickly set up a development environment for PHP projects.

## Build and Push Docker Image

1. Build the new Docker image:

sudo docker build --no-cache -t my_apache_php_image .


2. Tag the new Docker image:

sudo docker tag your-tag-name:latest your-docker-hub-account/image-name:latest


3. Push the Docker image to Docker Hub:

sudo docker push your-docker-hub-account/image-name:latest


## Usage

Follow the steps below to use the setup:

1. Clone the repository.

2. Update the `.env` file with your desired values:

MYSQL_HOST=mysql

MYSQL_PORT=3306

MYSQL_ROOT_PASSWORD=your-password


3. Run the Docker Compose file. Before running, make sure to create the necessary Docker volumes to mount. 
Also, ensure that the required folders, such as `/var/www/html/`, are created on your host machine and have the appropriate permissions.

docker-compose up -d

4. Apache2, PHP5, MySQL5, and phpMyAdmin will be installed and configured.

- Apache2 is running at http://localhost:88. You can run your PHP projects by placing them in the `/var/www/html` folder on your host machine.

- phpMyAdmin is running at http://localhost:99. Use the MySQL credentials to log in.

**Note:** You can modify the ports in the `docker-compose.yml` file to run Apache, MySQL, and phpMyAdmin on different ports according to your requirements.

The PHP5 and Apache2 docker image is available at https://hub.docker.com/r/kmahesh541/php5-apache2-mysql5

