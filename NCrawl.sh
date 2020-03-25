#!/bin/bash
echo "INJECTING URLS"
bin/nutch inject crawl/crawldb urls
echo "GENRATING A FETCH LIST"
bin/nutch generate crawl/crawldb crawl/segments
s1=`ls -d crawl/segments/2* | tail -1`
echo $s1
echo "RUNNING THE FETCHER"
bin/nutch fetch $s1
echo "PARSING"
bin/nutch parse $s1
echo "UPDATING DB WITH THE RESULTS OF THE FETCH"
bin/nutch updatedb crawl/crawldb $s1

echo "GENERATING AND FETCHING A NEW SEGMENT CONTAINING THE TOP-SCORING 1,000 PAGES"
echo "GENERATING THE SEGMENT"
bin/nutch generate crawl/crawldb crawl/segments -topN 1000
s2=`ls -d crawl/segments/2* | tail -1`
echo $s2
echo "FETCHING SEGMENT"
bin/nutch fetch $s2
echo "PARSING SEGMENT"
bin/nutch parse $s2
echo "UPDATEING THE DB"
bin/nutch updatedb crawl/crawldb $s2

echo "DOING THE SAME, ONE MORE TIME (ROUND)"
bin/nutch generate crawl/crawldb crawl/segments -topN 1000
s3=`ls -d crawl/segments/2* | tail -1`
echo $s3

bin/nutch fetch $s3
bin/nutch parse $s3
bin/nutch updatedb crawl/crawldb $s3

echo "INVERTING LINKS"
bin/nutch invertlinks crawl/linkdb -dir crawl/segments

echo "INDEXING TO SOLR"
s1=`ls -d crawl/segments/2* | tail -1`
s2=`ls -d crawl/segments/2* | tail -2`
s3=`ls -d crawl/segments/2* | tail -3`
bin/nutch index crawl/crawldb/ -linkdb crawl/linkdb/$s1/ -filter -normalize -deleteGone
bin/nutch index crawl/crawldb/ -linkdb crawl/linkdb/$s2/ -filter -normalize -deleteGone
bin/nutch index crawl/crawldb/ -linkdb crawl/linkdb/$s3/ -filter -normalize -deleteGone

echo "CLEANING THE SOLR"
bin/nutch clean crawl/crawldb/ http://localhost:8983/solr
echo "ENDED"

