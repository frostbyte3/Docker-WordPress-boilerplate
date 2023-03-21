rm -rf devdb
mkdir -p devdb
echo "Dumping WordPress DB..."
ssh -i 'SSH_KEY' USER@HOST 'mysqldump -u MYSQL_USER -p --column-statistics=0 -h MYSQL_HOST -P 3306 WP_DB' > devdb/wordpress.sql
echo "mysql -u root --password=ROOT_PASS WP_DB -e 'update wp_options set option_value='http://localhost/' where option_name = 'siteurl'; update wp_options set option_value='http://localhost/' where option_name = 'home';'"
