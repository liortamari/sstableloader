# sstableloader

This repo was created to test cassandra sstableloader streaming bug 
https://issues.apache.org/jira/browse/CASSANDRA-16349

which is supposed to be fixed in future version 4.0.4
#
The ```.env``` file enables testing with different version of cassandra image.

To run the test:
```
docker-compose down -v && docker-compose up -d && docker-compose ps &&  docker-compose exec cass1 /test.sh; docker-compose ps
```
#

Version 3.11.11 works fine but when running with version 4.0.X the test will encounter exceptions such as:

```
java.util.concurrent.ExecutionException: org.apache.cassandra.streaming.StreamException: Stream failed
	at com.google.common.util.concurrent.AbstractFuture.getDoneValue(AbstractFuture.java:552)
	at com.google.common.util.concurrent.AbstractFuture.get(AbstractFuture.java:533)
	at org.apache.cassandra.tools.BulkLoader.load(BulkLoader.java:101)
	at org.apache.cassandra.tools.BulkLoader.main(BulkLoader.java:51)
Caused by: org.apache.cassandra.streaming.StreamException: Stream failed
	at org.apache.cassandra.streaming.management.StreamEventJMXNotifier.onFailure(StreamEventJMXNotifier.java:88)
	at com.google.common.util.concurrent.Futures$CallbackListener.run(Futures.java:1056)
	at com.google.common.util.concurrent.DirectExecutor.execute(DirectExecutor.java:30)
	at com.google.common.util.concurrent.AbstractFuture.executeListener(AbstractFuture.java:1138)
	at com.google.common.util.concurrent.AbstractFuture.complete(AbstractFuture.java:958)
	at com.google.common.util.concurrent.AbstractFuture.setException(AbstractFuture.java:748)
	at org.apache.cassandra.streaming.StreamResultFuture.maybeComplete(StreamResultFuture.java:220)
	at org.apache.cassandra.streaming.StreamResultFuture.handleSessionComplete(StreamResultFuture.java:196)
	at org.apache.cassandra.streaming.StreamSession.closeSession(StreamSession.java:506)
	at org.apache.cassandra.streaming.StreamSession.complete(StreamSession.java:837)
	at org.apache.cassandra.streaming.StreamSession.messageReceived(StreamSession.java:596)
	at org.apache.cassandra.streaming.async.StreamingInboundHandler$StreamDeserializingTask.run(StreamingInboundHandler.java:189)
	at io.netty.util.concurrent.FastThreadLocalRunnable.run(FastThreadLocalRunnable.java:30)
	at java.base/java.lang.Thread.run(Unknown Source)
Exception in thread "main" org.apache.cassandra.tools.BulkLoadException: java.util.concurrent.ExecutionException: org.apache.cassandra.streaming.StreamException: Stream failed
	at org.apache.cassandra.tools.BulkLoader.load(BulkLoader.java:116)
	at org.apache.cassandra.tools.BulkLoader.main(BulkLoader.java:51)
Caused by: java.util.concurrent.ExecutionException: org.apache.cassandra.streaming.StreamException: Stream failed
	at com.google.common.util.concurrent.AbstractFuture.getDoneValue(AbstractFuture.java:552)
	at com.google.common.util.concurrent.AbstractFuture.get(AbstractFuture.java:533)
	at org.apache.cassandra.tools.BulkLoader.load(BulkLoader.java:101)
	... 1 more
Caused by: org.apache.cassandra.streaming.StreamException: Stream failed
	at org.apache.cassandra.streaming.management.StreamEventJMXNotifier.onFailure(StreamEventJMXNotifier.java:88)
	at com.google.common.util.concurrent.Futures$CallbackListener.run(Futures.java:1056)
	at com.google.common.util.concurrent.DirectExecutor.execute(DirectExecutor.java:30)
	at com.google.common.util.concurrent.AbstractFuture.executeListener(AbstractFuture.java:1138)
	at com.google.common.util.concurrent.AbstractFuture.complete(AbstractFuture.java:958)
	at com.google.common.util.concurrent.AbstractFuture.setException(AbstractFuture.java:748)
	at org.apache.cassandra.streaming.StreamResultFuture.maybeComplete(StreamResultFuture.java:220)
	at org.apache.cassandra.streaming.StreamResultFuture.handleSessionComplete(StreamResultFuture.java:196)
	at org.apache.cassandra.streaming.StreamSession.closeSession(StreamSession.java:506)
	at org.apache.cassandra.streaming.StreamSession.complete(StreamSession.java:837)
	at org.apache.cassandra.streaming.StreamSession.messageReceived(StreamSession.java:596)
	at org.apache.cassandra.streaming.async.StreamingInboundHandler$StreamDeserializingTask.run(StreamingInboundHandler.java:189)
	at io.netty.util.concurrent.FastThreadLocalRunnable.run(FastThreadLocalRunnable.java:30)
	at java.base/java.lang.Thread.run(Unknown Source)
```