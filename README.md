## magento2-nginx-redis-varnish-deployment

**Magento 2 Installation and Configuration**

Please follow the instructions below to complete the technical assessment:

### 1. Server Setup
- Create a new account on AWS to utilize AWS services.
- Alternatively, you may use DigitalOcean.

- Launch a server instance running Debian 12.

### 2. Install Required Components
- Install the following software packages:

- PHP 8.3

- MySQL 8

- NGINX

- Elasticsearch

### 3. Magento 2 Installation
- Install the latest version of Magento 2 using Composer.

- Include Sample Data and configure it to work with Elasticsearch.

- Set the base domain to: **test.mgt.com**
 (Configure this in your /etc/hosts file, e.g., 127.0.0.1 test.mgt.com)

### 4. Redis Configuration

- Install Redis Server.

- Configure Magento to use Redis for both:
  - Cache storage

  - Session storage

### 5. Permissions and User Configuration

- Change ownership of all Magento files and folders to:

  - User: test-ssh

  - Group: clp

- Configure NGINX to run as user test-ssh.

- Create a PHP-FPM pool running as test-ssh:clp and link it to your NGINX virtual host.

### 6. PHPMyAdmin
- Install and configure PHPMyAdmin using the domain: **pma.mgt.com**
 (Add this domain to your /etc/hosts file similarly.)

### 7. HTTPS Configuration
- Configure NGINX to redirect all HTTP requests to HTTPS.
   
- Set all Magento store URLs to use HTTPS.

- Use a self-signed SSL certificate for HTTPS setup.

### 8. Varnish Configuration
- Install Varnish.

- Configure it to work with Magento for full-page caching.