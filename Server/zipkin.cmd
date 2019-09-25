@echo off
set RABBIT_ADDRESSES=localhost:5672
set STORAGE_TYPE=mysql
set MYSQL_DB=bd_tracer
set MYSQL_USER=user_tracer
set MYSQL_PASS=123@@cris
java -jar ./zipkin-server-2.17.0-exec.jar