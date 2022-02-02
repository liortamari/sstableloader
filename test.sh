#!/bin/bash

function cql() {
  s="${1}"
  if [[ "${CAS_CONS}" != "ONE" ]]; then
    s="CONSISTENCY ${CAS_CONS}; ${1}"
  fi
  cqlsh -e "${s}"
}

echo "WAITING FOR CLUSTER"

c=0
while [[ $c != 3 ]]
do
  sleep 2
  c=$(nodetool status 2>/dev/null | tr " " "\n" | grep -c "UN")
  echo $c
done

echo "TEST CQLSH"

m=""
while [[ -z $m ]]
do
  sleep 2
  m=$(cqlsh -e "DESCRIBE KEYSPACES;" 2>/dev/null)
  echo $m
done

echo "STARTING"

cql "\
  CREATE KEYSPACE music WITH replication = {'class': 'SimpleStrategy', 'replication_factor' : 3};"

cql "\
  CREATE TABLE music.songs (\
  song_id int, \
  song_name text, \
  artist text, \
  PRIMARY KEY (song_id));"

cql "\
  INSERT INTO music.songs (song_id, song_name, artist) \
  VALUES (1, 'Song1', 'Alice');"

cql "\
  INSERT INTO music.songs (song_id, song_name, artist) \
  VALUES (2, 'Song1', 'Bob');"

cql "\
  INSERT INTO music.songs (song_id, song_name, artist) \
  VALUES (3, 'Song2', 'Alice');"

cql "\
  SELECT * FROM music.songs;"

nodetool snapshot

cql "\
  TRUNCATE music.songs;"

cql "\
  SELECT * FROM music.songs;"

mkdir /tmp/music
mkdir /tmp/music/songs

cp /var/lib/cassandra/data/music/songs*/snapshots/1*/* /tmp/music/songs/

_ip_address() {
	ip address | awk '
		$1 != "inet" { next } # only lines with ip addresses
		$NF == "lo" { next } # skip loopback devices
		$2 ~ /^127[.]/ { next } # skip loopback addresses
		$2 ~ /^169[.]254[.]/ { next } # skip link-local addresses
		{
			gsub(/\/.+$/, "", $2)
			print $2
			exit
		}
	'
}

echo "RUNNING sstableloader -d  "$(_ip_address)" -v /tmp/music/songs"

sstableloader -d  "$(_ip_address)" -v /tmp/music/songs

cql "\
  SELECT * FROM music.songs;"

nodetool status
