CREATE DATABASE IF NOT EXISTS cloudshopt_users;
CREATE DATABASE IF NOT EXISTS cloudshopt_products;

GRANT ALL PRIVILEGES ON cloudshopt_users.* TO 'cloudshoptuser'@'%';
GRANT ALL PRIVILEGES ON cloudshopt_products.* TO 'cloudshoptuser'@'%';
FLUSH PRIVILEGES;