Cleaning Solr’s core (de facto Lucene’s index)

1. curl http://localhost:8983/solr/nutch/update --data '<delete><query>*:*</query></delete>' -H 'Content-type:text/xml; charset=utf-8'
2. Restart the Solr. 
