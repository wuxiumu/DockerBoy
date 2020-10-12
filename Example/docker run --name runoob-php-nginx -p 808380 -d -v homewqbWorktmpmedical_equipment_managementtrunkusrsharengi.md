docker run --name runoob-php-nginx -p 8083:80 -d -v /home/wqb/Work/tmp/medical_equipment_management/trunk:/usr/share/nginx/html:ro -v /home/wqb/Work/nginx/conf/conf.d:/etc/nginx/conf.d:ro --link repsys-fpm:php nginx



```
docker run --name  myphp-la -v /home/wqb/Downloads/demo.laravel-admin.org-master/public:/www  -d php:7.0

docker run --name runoob-php-nginx1 -p 8084:80 -d -v /home/wqb/Downloads/demo.laravel-admin.org-master/public:/usr/share/nginx/html:ro -v /home/wqb/Downloads/demo.laravel-admin.org-master/nginx/conf/conf.d:/etc/nginx/conf.d:ro --link myphp-la:php nginx
reps_oa_admin

	repsoa@20150810
```

reps_oa_admin