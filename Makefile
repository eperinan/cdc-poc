start:
	docker-compose up --build &
	sleep 20
	docker-compose exec connect cp /usr/share/java/kafka-connect-jdbc-mysql/mysql-connector-java-5.1.47-bin.jar /usr/share/java/kafka-connect-jdbc

clean:
	docker-compose stop; docker-compose down; docker-compose rm;