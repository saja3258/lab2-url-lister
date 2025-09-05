USER=$(shell whoami)

##
## Configure the Hadoop classpath for the GCP dataproc enviornment
##

HADOOP_CLASSPATH=$(shell hadoop classpath)

WordCount1.jar: WordCount1.java
	javac -classpath $(HADOOP_CLASSPATH) -d ./ WordCount1.java
	jar cf WordCount1.jar WordCount1*.class	
	-rm -f WordCount1*.class

prepare:
	-hdfs dfs -mkdir input
	curl https://en.wikipedia.org/wiki/Apache_Hadoop > /tmp/input.txt
	hdfs dfs -put /tmp/input.txt input/file01
	curl https://en.wikipedia.org/wiki/MapReduce > /tmp/input.txt
	hdfs dfs -put /tmp/input.txt input/file02

filesystem:
	-hdfs dfs -mkdir /user
	-hdfs dfs -mkdir /user/$(USER)

run: WordCount1.jar
	-rm -rf output
	hadoop jar WordCount1.jar WordCount1 input output


##
## You may need to change the path for this depending
## on your Hadoop / java setup
##
HADOOP_V=3.3.4
STREAM_JAR = /usr/local/hadoop-$(HADOOP_V)/share/hadoop/tools/lib/hadoop-streaming-$(HADOOP_V).jar

stream:
	-rm -rf stream-output
	hadoop jar $(STREAM_JAR) \
	-mapper Mapper.py \
	-reducer Reducer.py \
	-file Mapper.py -file Reducer.py \
	-input input -output stream-output
urlstream:
	$(HADOOP_HOME)/bin/hadoop fs -rm -r output || true
	$(HADOOP_HOME)/bin/hadoop jar $(HADOOP_HOME)/share/hadoop/tools/lib/hadoop-streaming-*.jar \
		-files URLMapper.py,URLReducer.py \
		-mapper URLMapper.py \
		-reducer URLReducer.py \
		-input input \
		-output output

testpython:
	cat input/file01 input/file02 | python3 URLMapper.py | sort | python3 URLReducer.py

testmapper:
	cat input/file01 | python3 URLMapper.py | head -20

viewresults:
	$(HADOOP_HOME)/bin/hadoop fs -cat output/part-r-00000 | head -20

cleanup:
	$(HADOOP_HOME)/bin/hadoop fs -rm -r output || true

filesystem:
	$(HADOOP_HOME)/bin/hdfs dfs -mkdir -p /user/$(USER)

urlstream-alt:
	$(HADOOP_HOME)/bin/hadoop fs -rm -r output || true
	$(HADOOP_HOME)/bin/hadoop jar $(HADOOP_HOME)/share/hadoop/tools/lib/hadoop-streaming-3.2.2.jar \
		-files URLMapper.py,URLReducer.py \
		-mapper URLMapper.py \
		-reducer URLReducer.py \
		-input input \
		-output output
urlstream-local:
	rm -rf output || true
	$(HADOOP_HOME)/bin/hadoop jar $(HADOOP_HOME)/share/hadoop/tools/lib/hadoop-streaming-*.jar \
		-files URLMapper.py,URLReducer.py \
		-mapper URLMapper.py \
		-reducer URLReducer.py \
		-input input \
		-output output