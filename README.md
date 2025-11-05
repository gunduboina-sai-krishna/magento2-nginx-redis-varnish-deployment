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


## NOTES:
- **Redis:** port - 6379 (TCP)
- **Varnish: Default ports** 
  - 6081: This is the default port for Varnish to listen for incoming HTTP traffic.
  - 6082: This port is used for the Varnish administration console, varnishadm

## version:
| Component     | Version        |
| ------------- | -------------- |
| Elasticsearch | **7.17.21** ✅  |
| Redis         | 7.2.x          |
| MySQL         | 8.0.x          |
| Nginx         | 1.26+          |
| PHP           | 8.3            |
| Magento       | 2.4.7 or 2.4.8 |


## mysql issues:

- Install MySQL 8 via the Oracle Debian package directly (no repo):
```
sudo wget https://dev.mysql.com/get/mysql-apt-config_0.8.36-1_all.deb
sudo dpkg -i mysql-apt-config_0.8.36-1_all.deb
sudo apt update --allow-unauthenticated
sudo apt install -y mysql-server
```
- Err:3 http://repo.mysql.com/apt/debian bookworm InRelease
  The following signatures were invalid: EXPKEYSIG B7B3B788A8D3785C MySQL Release Engineering <mysql-build@oss.oracle.com>
- To fix this - remove the old key B7B3B788A8D3785C
       ```
        sudo apt-key del B7B3B788A8D3785C 2>/dev/null || true
        sudo rm -f /etc/apt/trusted.gpg.d/mysql*.gpg
        sudo rm -f /usr/share/keyrings/mysql*.gpg
        sudo rm -f /etc/apt/sources.list.d/mysql*.list
        sudo apt clean
        ```
- Re-add mysql repo
     ```
      sudo mkdir -p /usr/share/keyrings
      wget -O /usr/share/keyrings/mysql.gpg https://repo.mysql.com/RPM-GPG-KEY-mysql-2023
      echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mysql.gpg] https://repo.mysql.com/apt/debian bookworm mysql-8.0" | \
      sudo tee /etc/apt/sources.list.d/mysql.list
      ```

- Error: Err:8 https://repo.mysql.com/apt/debian bookworm InRelease
  The following signatures couldn't be verified because the public key is not available: NO_PUBKEY B7B3B788A8D3785C
  Reading package lists... Done
- fix ```
        # 1. Export the key you just imported to a file
          sudo apt-key export B7B3B788A8D3785C | sudo gpg --dearmor | sudo tee /usr/share/keyrings/mysql.gpg > /dev/null

          # 2. Make sure permissions are correct
          sudo chmod 644 /usr/share/keyrings/mysql.gpg

          # 3. Recreate the MySQL repo file
          echo "deb [arch=amd64 signed-by=/usr/share/keyrings/mysql.gpg] https://repo.mysql.com/apt/debian bookworm mysql-8.0" | \
          sudo tee /etc/apt/sources.list.d/mysql.list

          # 4. Update apt again
          sudo apt update
        ```
      
- nginx: 
  ```
  sudo sed -i 's/^user .*/user test-ssh clp;/' /etc/nginx/nginx.conf
  ```


  ```
  php bin/magento setup:di:compile
  php bin/magento setup:static-content:deploy -f
  php bin/magento cache:flush
  php bin/magento indexer:reindex
 ```  