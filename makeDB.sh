#!/bin/bash
mysql -u root -p -e "DROP DATABASE if exists wordpress; CREATE DATABASE wordpress;"
mysql -u root -p wordpress < /devdb/wordpress.sql
mysql -u root -p -e "use wordpress;"
mysql -u root -p -e "update wp_options set option_value="http://localhost" where option_name = 'siteurl'; update wp_options set option_value="http://localhost" where option_name = 'home';"