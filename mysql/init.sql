CREATE DATABASE IF NOT EXISTS cloudshopt_users;
CREATE DATABASE IF NOT EXISTS cloudshopt_products;
CREATE DATABASE IF NOT EXISTS cloudshopt_orders;
CREATE DATABASE IF NOT EXISTS cloudshopt_payments;

GRANT ALL PRIVILEGES ON cloudshopt_users.* TO 'cloudshoptuser'@'%';
GRANT ALL PRIVILEGES ON cloudshopt_products.* TO 'cloudshoptuser'@'%';
GRANT ALL PRIVILEGES ON cloudshopt_orders.* TO 'cloudshoptuser'@'%';
GRANT ALL PRIVILEGES ON cloudshopt_payments.* TO 'cloudshoptuser'@'%';
FLUSH PRIVILEGES;