Cleaning Solr’s core (de facto Lucene’s index)

1. curl http://<ip_address>:8983/solr/<collection_name>/update --data '<delete><query>*:*</query></delete>' -H 'Content-type:text/xml; charset=utf-8'; 2. Restart the Solr. 
