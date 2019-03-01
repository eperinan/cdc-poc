# Change Data Capture PoC with Debezium

### Databases
* PostgreSQL instance.
* Mysql instance.
* Elasticsearch instance.
* MongoDB Cluster.

### Services
* Zookeeper: localhost:2181
* Kafka Broker: broker0:9092, broker1:9093, broker2:9093
* Schema Registry: http://localhost:8081
* Connect: http://localhost:8083 (Api Rest)
* Connect UI: http://localhost:8000
* KSQL Server: http://localhost:8088
* Rest Proxy: http://localhost:8086
* Postgres: localhost:5432
* Mysql: localhost:3306
* Elastichsearch: http://localhost:9200
* Control Center UI: http://localhost:902

### Connectors

* https://repo1.maven.org/maven2/io/debezium/debezium-connector-mongodb/0.9.2.Final/debezium-connector-mongodb-0.9.2.Final-plugin.tar.gz
* https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/0.9.2.Final/debezium-connector-mysql-0.9.2.Final-plugin.tar.gz

### Source connectors
 
#### Debezium Connector for MongoDB

Link: 
[https://debezium.io/docs/connectors/mongodb/](https://debezium.io/docs/connectors/mongodb/)

##### Commands to insert elements

`for ((i=1;i<=100;i++)); do docker exec -it data-training-cp_mongodb-primary_1 mongo --port 27017 --eval 'db.test.insert({c:200})'; done;`

`docker exec -it data-training-cp_mongodb-primary_1 mongo --port 27017 --eval 'db.test.insert({c:200})`

`docker exec -it data-training-cp_mongodb-primary_1 mongo --eval 'db.setSlaveOk();db.test.find()'`

##### Configuration for create a source job
```
{
    "name":"testsourcemongo",
    "connector.class" : "io.debezium.connector.mongodb.MongoDbConnector",
    "tasks.max" : "1",
    "mongodb.hosts" : "mongodb-primary:27017",
    "mongodb.name" : "test",
    "database.whitelist" : "test",
    "collection.whitelist" : "test.test",
    "key.converter" : "io.confluent.connect.avro.AvroConverter",
    "key.converter.schema.registry.url" : "http://schema-registry:8081",
    "value.converter" : "io.confluent.connect.avro.AvroConverter",
    "value.converter.schema.registry.url" : "http://schema-registry:8081",
    "internal.key.converter" : "org.apache.kafka.connect.json.JsonConverter",
    "internal.value.converter"  : "org.apache.kafka.connect.json.JsonConverter",
    "schema.compatibility" : "NONE"
}
```

#### Debezium Connector for Mysql

Link: 
[https://debezium.io/docs/connectors/mysql/](https://debezium.io/docs/connectors/mysql/)

##### Configuration for create a source job
```
{
  "connector.class": "io.debezium.connector.mysql.MySqlConnector",
  "name": "buena-broza-source",
  "database.history.kafka.topic": "schema_topic_mysql",
  "database.history.kafka.bootstrap.servers": "broker0:19092",
  "database.hostname": "mysql",
  "database.port": "3306",
  "database.user": "debezium",
  "database.password": "dbz",
  "database.server.name": "inventory",
  "database.whitelist": "inventory"
}
```

### Sink connectors

#### Kafka Connect S3

Link:
[https://docs.confluent.io/5.1.2/connect/kafka-connect-s3/index.html](https://docs.confluent.io/5.1.2/connect/kafka-connect-s3/index.html)

The S3 connector, currently available as a sink, allows you to export data from Kafka topics to S3 objects in either Avro or JSON formats. In addition, for certain data layouts, S3 connector exports data by guaranteeing exactly-once delivery semantics to consumers of the S3 objects it produces.

##### Configuration for create a sink job

```
{
  "storage.class": "io.confluent.connect.s3.storage.S3Storage",
  "partitioner.class": "io.confluent.connect.storage.partitioner.HourlyPartitioner",
  "flush.size": "5",
  "s3.bucket.name": "workshop-spotahome",
  "connector.class": "io.confluent.connect.s3.S3SinkConnector",
  "name": "s3-sink-connector",
  "topics": "mysql_search_listing",
  "format.class": "io.confluent.connect.s3.format.avro.AvroFormat",
  "s3.region": "eu-west-1",
  "locale": "es",
  "timezone": "Etc/UTC"
}
```
