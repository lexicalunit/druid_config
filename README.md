**Table of Contents**

- [Overview](#overview)
- [Issues](#issues)
  - [Not enough direct memory](#not-enough-direct-memory)
  - [Exception with one of the sequences](#exception-with-one-of-the-sequences)
  - [Coordinator Console Problems](#coordinator-console-problems)
- [Resolved Issues](#resolved-issues)
  - [No Task Logs](#no-task-logs)
  - [Index Task Fails](#index-task-fails)

Overview
===

Please see the included `.properties` files for the druid configuration of each node type. At the top of each file is a summary of system resources such as the number of processors the machine has, the size of main memory in bytes, etc...

My druid cluster consists of the following nodes:

* [3 historical](historical.properties)
* [1 overlord](overlord.properties)
* [1 middleManager](middleManager.properties)
* [1 broker](broker.properties)
* [1 coordinator](coordinator.properties)
* 1 mysql
* 1 zookeeper

**Each node is a seperate AWS EC2 instance**

Issues
===

Not enough direct memory
---

I get the following in my historical node log:

```
2014-10-29 21:30:44,610 INFO [main] io.druid.guice.JsonConfigurator - Loaded class[class io.druid.segment.loading.SegmentLoaderConfig] from props[druid.segmentCache.] as [SegmentLoaderConfig{locations=[StorageLocationConfig{path=/indexCache, maxSize=21207667507}], deleteOnRemove=true, dropSegmentDelayMillis=30000, infoDir=null}]
2014-10-29 21:30:44,615 INFO [main] io.druid.guice.JsonConfigurator - Loaded class[class io.druid.query.QueryConfig] from props[druid.query.] as [io.druid.query.QueryConfig@1159f15e]
2014-10-29 21:30:44,630 INFO [main] io.druid.guice.JsonConfigurator - Loaded class[class io.druid.query.search.search.SearchQueryConfig] from props[druid.query.search.] as [io.druid.query.search.search.SearchQueryConfig@60f1057]
2014-10-29 21:30:44,638 INFO [main] io.druid.guice.JsonConfigurator - Loaded class[class io.druid.query.groupby.GroupByQueryConfig] from props[druid.query.groupBy.] as [io.druid.query.groupby.GroupByQueryConfig@70095013]
2014-10-29 21:30:44,641 INFO [main] org.skife.config.ConfigurationObjectFactory - Assigning value [1142857142] for [druid.processing.buffer.sizeBytes] on [io.druid.query.DruidProcessingConfig#intermediateComputeSizeBytes()]
2014-10-29 21:30:44,644 INFO [main] org.skife.config.ConfigurationObjectFactory - Assigning value [7] for [druid.processing.numThreads] on [io.druid.query.DruidProcessingConfig#getNumThreads()]
2014-10-29 21:30:44,644 INFO [main] org.skife.config.ConfigurationObjectFactory - Using method itself for [${base_path}.columnCache.sizeBytes] on [io.druid.query.DruidProcessingConfig#columnCacheSizeBytes()]
2014-10-29 21:30:44,645 INFO [main] org.skife.config.ConfigurationObjectFactory - Assigning default value [processing-%s] for [${base_path}.formatString] on [com.metamx.common.concurrent.ExecutorServiceConfig#getFormatString()]
2014-10-29 21:30:44,726 WARN [main] io.druid.guice.DruidProcessingModule - Guice provision errors:

1) Not enough direct memory.  Please adjust -XX:MaxDirectMemorySize, druid.processing.buffer.sizeBytes, or druid.processing.numThreads: maxDirectMemory[4,294,967,296], memoryNeeded[9,142,857,136] = druid.processing.buffer.sizeBytes[1,142,857,142] * ( druid.processing.numThreads[7] + 1 )

1 error
com.google.inject.ProvisionException: Guice provision errors:

1) Not enough direct memory.  Please adjust -XX:MaxDirectMemorySize, druid.processing.buffer.sizeBytes, or druid.processing.numThreads: maxDirectMemory[4,294,967,296], memoryNeeded[9,142,857,136] = druid.processing.buffer.sizeBytes[1,142,857,142] * ( druid.processing.numThreads[7] + 1 )

1 error
	at io.druid.guice.DruidProcessingModule.getIntermediateResultsPool(DruidProcessingModule.java:87)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:606)
	at com.google.inject.internal.ProviderMethod.get(ProviderMethod.java:105)
	at com.google.inject.internal.ProviderInternalFactory.provision(ProviderInternalFactory.java:86)
	at com.google.inject.internal.InternalFactoryToInitializableAdapter.provision(InternalFactoryToInitializableAdapter.java:55)
	at com.google.inject.internal.ProviderInternalFactory.circularGet(ProviderInternalFactory.java:66)
	at com.google.inject.internal.InternalFactoryToInitializableAdapter.get(InternalFactoryToInitializableAdapter.java:47)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter$1.call(ProviderToInternalFactoryAdapter.java:46)
	at com.google.inject.internal.InjectorImpl.callInContext(InjectorImpl.java:1058)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter.get(ProviderToInternalFactoryAdapter.java:40)
	at com.google.inject.Scopes$1$1.get(Scopes.java:65)
	at com.google.inject.internal.InternalFactoryToProviderAdapter.get(InternalFactoryToProviderAdapter.java:41)
	at com.google.inject.internal.SingleParameterInjector.inject(SingleParameterInjector.java:38)
	at com.google.inject.internal.SingleParameterInjector.getAll(SingleParameterInjector.java:62)
	at com.google.inject.internal.ConstructorInjector.provision(ConstructorInjector.java:107)
	at com.google.inject.internal.ConstructorInjector.construct(ConstructorInjector.java:88)
	at com.google.inject.internal.ConstructorBindingImpl$Factory.get(ConstructorBindingImpl.java:269)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter$1.call(ProviderToInternalFactoryAdapter.java:46)
	at com.google.inject.internal.InjectorImpl.callInContext(InjectorImpl.java:1058)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter.get(ProviderToInternalFactoryAdapter.java:40)
	at com.google.inject.Scopes$1$1.get(Scopes.java:65)
	at com.google.inject.internal.InternalFactoryToProviderAdapter.get(InternalFactoryToProviderAdapter.java:41)
	at com.google.inject.internal.SingleParameterInjector.inject(SingleParameterInjector.java:38)
	at com.google.inject.internal.SingleParameterInjector.getAll(SingleParameterInjector.java:62)
	at com.google.inject.internal.ConstructorInjector.provision(ConstructorInjector.java:107)
	at com.google.inject.internal.ConstructorInjector.construct(ConstructorInjector.java:88)
	at com.google.inject.internal.ConstructorBindingImpl$Factory.get(ConstructorBindingImpl.java:269)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter$1.call(ProviderToInternalFactoryAdapter.java:46)
	at com.google.inject.internal.InjectorImpl.callInContext(InjectorImpl.java:1058)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter.get(ProviderToInternalFactoryAdapter.java:40)
	at com.google.inject.Scopes$1$1.get(Scopes.java:65)
	at com.google.inject.internal.InternalFactoryToProviderAdapter.get(InternalFactoryToProviderAdapter.java:41)
	at com.google.inject.internal.FactoryProxy.get(FactoryProxy.java:56)
	at com.google.inject.internal.InjectorImpl$3$1.call(InjectorImpl.java:1005)
	at com.google.inject.internal.InjectorImpl.callInContext(InjectorImpl.java:1058)
	at com.google.inject.internal.InjectorImpl$3.get(InjectorImpl.java:1001)
	at com.google.inject.spi.ProviderLookup$1.get(ProviderLookup.java:90)
	at com.google.inject.spi.ProviderLookup$1.get(ProviderLookup.java:90)
	at com.google.inject.multibindings.MapBinder$RealMapBinder$2.get(MapBinder.java:389)
	at com.google.inject.multibindings.MapBinder$RealMapBinder$2.get(MapBinder.java:385)
	at com.google.inject.internal.ProviderInternalFactory.provision(ProviderInternalFactory.java:86)
	at com.google.inject.internal.InternalFactoryToInitializableAdapter.provision(InternalFactoryToInitializableAdapter.java:55)
	at com.google.inject.internal.ProviderInternalFactory.circularGet(ProviderInternalFactory.java:66)
	at com.google.inject.internal.InternalFactoryToInitializableAdapter.get(InternalFactoryToInitializableAdapter.java:47)
	at com.google.inject.internal.SingleParameterInjector.inject(SingleParameterInjector.java:38)
	at com.google.inject.internal.SingleParameterInjector.getAll(SingleParameterInjector.java:62)
	at com.google.inject.internal.ConstructorInjector.provision(ConstructorInjector.java:107)
	at com.google.inject.internal.ConstructorInjector.construct(ConstructorInjector.java:88)
	at com.google.inject.internal.ConstructorBindingImpl$Factory.get(ConstructorBindingImpl.java:269)
	at com.google.inject.internal.FactoryProxy.get(FactoryProxy.java:56)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter$1.call(ProviderToInternalFactoryAdapter.java:46)
	at com.google.inject.internal.InjectorImpl.callInContext(InjectorImpl.java:1058)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter.get(ProviderToInternalFactoryAdapter.java:40)
	at com.google.inject.Scopes$1$1.get(Scopes.java:65)
	at com.google.inject.internal.InternalFactoryToProviderAdapter.get(InternalFactoryToProviderAdapter.java:41)
	at com.google.inject.internal.SingleParameterInjector.inject(SingleParameterInjector.java:38)
	at com.google.inject.internal.SingleParameterInjector.getAll(SingleParameterInjector.java:62)
	at com.google.inject.internal.ConstructorInjector.provision(ConstructorInjector.java:107)
	at com.google.inject.internal.ConstructorInjector.construct(ConstructorInjector.java:88)
	at com.google.inject.internal.ConstructorBindingImpl$Factory.get(ConstructorBindingImpl.java:269)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter$1.call(ProviderToInternalFactoryAdapter.java:46)
	at com.google.inject.internal.InjectorImpl.callInContext(InjectorImpl.java:1058)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter.get(ProviderToInternalFactoryAdapter.java:40)
	at com.google.inject.Scopes$1$1.get(Scopes.java:65)
	at com.google.inject.internal.InternalFactoryToProviderAdapter.get(InternalFactoryToProviderAdapter.java:41)
	at com.google.inject.internal.SingleParameterInjector.inject(SingleParameterInjector.java:38)
	at com.google.inject.internal.SingleParameterInjector.getAll(SingleParameterInjector.java:62)
	at com.google.inject.internal.ConstructorInjector.provision(ConstructorInjector.java:107)
	at com.google.inject.internal.ConstructorInjector.construct(ConstructorInjector.java:88)
	at com.google.inject.internal.ConstructorBindingImpl$Factory.get(ConstructorBindingImpl.java:269)
	at com.google.inject.internal.InjectorImpl$3$1.call(InjectorImpl.java:1005)
	at com.google.inject.internal.InjectorImpl.callInContext(InjectorImpl.java:1058)
	at com.google.inject.internal.InjectorImpl$3.get(InjectorImpl.java:1001)
	at com.google.inject.internal.InjectorImpl.getInstance(InjectorImpl.java:1040)
	at io.druid.server.metrics.MetricsModule.getMonitorScheduler(MetricsModule.java:83)
	at sun.reflect.NativeMethodAccessorImpl.invoke0(Native Method)
	at sun.reflect.NativeMethodAccessorImpl.invoke(NativeMethodAccessorImpl.java:57)
	at sun.reflect.DelegatingMethodAccessorImpl.invoke(DelegatingMethodAccessorImpl.java:43)
	at java.lang.reflect.Method.invoke(Method.java:606)
	at com.google.inject.internal.ProviderMethod.get(ProviderMethod.java:105)
	at com.google.inject.internal.ProviderInternalFactory.provision(ProviderInternalFactory.java:86)
	at com.google.inject.internal.InternalFactoryToInitializableAdapter.provision(InternalFactoryToInitializableAdapter.java:55)
	at com.google.inject.internal.ProviderInternalFactory.circularGet(ProviderInternalFactory.java:66)
	at com.google.inject.internal.InternalFactoryToInitializableAdapter.get(InternalFactoryToInitializableAdapter.java:47)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter$1.call(ProviderToInternalFactoryAdapter.java:46)
	at com.google.inject.internal.InjectorImpl.callInContext(InjectorImpl.java:1058)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter.get(ProviderToInternalFactoryAdapter.java:40)
	at io.druid.guice.LifecycleScope$1.get(LifecycleScope.java:49)
	at com.google.inject.internal.InternalFactoryToProviderAdapter.get(InternalFactoryToProviderAdapter.java:41)
	at com.google.inject.internal.FactoryProxy.get(FactoryProxy.java:56)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter$1.call(ProviderToInternalFactoryAdapter.java:46)
	at com.google.inject.internal.InjectorImpl.callInContext(InjectorImpl.java:1058)
	at com.google.inject.internal.ProviderToInternalFactoryAdapter.get(ProviderToInternalFactoryAdapter.java:40)
	at com.google.inject.Scopes$1$1.get(Scopes.java:65)
	at com.google.inject.internal.InternalFactoryToProviderAdapter.get(InternalFactoryToProviderAdapter.java:41)
	at com.google.inject.internal.InternalInjectorCreator$1.call(InternalInjectorCreator.java:205)
	at com.google.inject.internal.InternalInjectorCreator$1.call(InternalInjectorCreator.java:199)
	at com.google.inject.internal.InjectorImpl.callInContext(InjectorImpl.java:1051)
	at com.google.inject.internal.InternalInjectorCreator.loadEagerSingletons(InternalInjectorCreator.java:199)
	at com.google.inject.internal.InternalInjectorCreator.injectDynamically(InternalInjectorCreator.java:180)
	at com.google.inject.internal.InternalInjectorCreator.build(InternalInjectorCreator.java:110)
	at com.google.inject.Guice.createInjector(Guice.java:96)
	at com.google.inject.Guice.createInjector(Guice.java:73)
	at com.google.inject.Guice.createInjector(Guice.java:62)
	at io.druid.initialization.Initialization.makeInjectorWithModules(Initialization.java:349)
	at io.druid.cli.GuiceRunnable.makeInjector(GuiceRunnable.java:56)
	at io.druid.cli.ServerRunnable.run(ServerRunnable.java:39)
	at io.druid.cli.Main.main(Main.java:90)
```

Exception with one of the sequences
---

When trying to run a simple topN query after restarting my cluster, I get the following response:

```bash
$ dq "http://${druid_broker}:8080/druid/v2/?pretty" topn_by_channel.json 

curl --silent --show-error -d @topn_by_channel.json -H 'content-type: application/json' 'http://broker-ip:8080/druid/v2/' --data-urlencode 'pretty' | python -mjson.tool | pygmentize -l json -f terminal256

{
    "error": "null exception"
}

real    0m1.964s
user    0m0.003s
sys 0m0.002s
```

Looking in the broker node's log, I see the following entry:

```
2014-10-29 21:37:52,655 INFO [qtp1289413694-43] io.druid.server.QueryResource - null exception [3941ccaa-f425-4dfc-913f-8f3faa08d953]
```

Looking in the historical node's log, I see the the following:

```
2014-10-29 21:40:58,826 INFO [topN_click_conversion_[2014-04-11T00:00:00.000Z/2014-04-12T00:00:00.000Z]] io.druid.guice.DruidProcessingModule$IntermediateProcessingBufferPool - Allocating new intermediate processing buffer[219] of size[1,142,857,142]
2014-10-29 21:40:58,826 INFO [topN_click_conversion_[2014-04-14T00:00:00.000Z/2014-04-15T00:00:00.000Z]] io.druid.guice.DruidProcessingModule$IntermediateProcessingBufferPool - Allocating new intermediate processing buffer[220] of size[1,142,857,142]
2014-10-29 21:40:58,826 INFO [topN_click_conversion_[2014-04-17T00:00:00.000Z/2014-04-18T00:00:00.000Z]] io.druid.guice.DruidProcessingModule$IntermediateProcessingBufferPool - Allocating new intermediate processing buffer[221] of size[1,142,857,142]
2014-10-29 21:40:58,826 INFO [topN_click_conversion_[2014-04-22T00:00:00.000Z/2014-04-23T00:00:00.000Z]] io.druid.guice.DruidProcessingModule$IntermediateProcessingBufferPool - Allocating new intermediate processing buffer[222] of size[1,142,857,142]
[Full GC[CMS: 15246K->15444K(3145728K), 0.1036770 secs] 314761K->15444K(4089472K), [CMS Perm : 39889K->39889K(66556K)], 0.1037830 secs] [Times: user=0.11 sys=0.00, real=0.10 secs] 
[Full GC[CMS: 15444K->15444K(3145728K), 0.0891800 secs] 15444K->15444K(4089472K), [CMS Perm : 39889K->39889K(66556K)], 0.0892730 secs] [Times: user=0.09 sys=0.00, real=0.09 secs] 
[Full GC[CMS: 15444K->15444K(3145728K), 0.0885340 secs] 15444K->15444K(4089472K), [CMS Perm : 39889K->39889K(66556K)], 0.0886360 secs] [Times: user=0.09 sys=0.00, real=0.09 secs] 
[Full GC[CMS: 15444K->15444K(3145728K), 0.0892900 secs] 17841K->15444K(4089472K), [CMS Perm : 39889K->39889K(66556K)], 0.0893870 secs] [Times: user=0.09 sys=0.00, real=0.09 secs] 
2014-10-29 21:40:59,199 ERROR [processing-6] io.druid.query.ChainedExecutionQueryRunner - Exception with one of the sequences!
java.lang.NullPointerException
	at io.druid.query.topn.PooledTopNAlgorithm.cleanup(PooledTopNAlgorithm.java:231)
	at io.druid.query.topn.PooledTopNAlgorithm.cleanup(PooledTopNAlgorithm.java:37)
	at io.druid.query.topn.TopNMapFn.apply(TopNMapFn.java:64)
	at io.druid.query.topn.TopNMapFn.apply(TopNMapFn.java:29)
	at io.druid.query.topn.TopNQueryEngine$1.apply(TopNQueryEngine.java:84)
	at io.druid.query.topn.TopNQueryEngine$1.apply(TopNQueryEngine.java:79)
	at com.metamx.common.guava.MappingYieldingAccumulator.accumulate(MappingYieldingAccumulator.java:57)
	at com.metamx.common.guava.FilteringYieldingAccumulator.accumulate(FilteringYieldingAccumulator.java:69)
	at com.metamx.common.guava.MappingYieldingAccumulator.accumulate(MappingYieldingAccumulator.java:57)
	at com.metamx.common.guava.BaseSequence.makeYielder(BaseSequence.java:104)
	at com.metamx.common.guava.BaseSequence.toYielder(BaseSequence.java:81)
	at com.metamx.common.guava.MappedSequence.toYielder(MappedSequence.java:46)
	at com.metamx.common.guava.ResourceClosingSequence.toYielder(ResourceClosingSequence.java:25)
	at com.metamx.common.guava.FilteredSequence.toYielder(FilteredSequence.java:52)
	at com.metamx.common.guava.MappedSequence.toYielder(MappedSequence.java:46)
	at com.metamx.common.guava.FilteredSequence.toYielder(FilteredSequence.java:52)
	at com.metamx.common.guava.ResourceClosingSequence.toYielder(ResourceClosingSequence.java:25)
	at com.metamx.common.guava.YieldingSequenceBase.accumulate(YieldingSequenceBase.java:18)
	at io.druid.query.MetricsEmittingQueryRunner$1.accumulate(MetricsEmittingQueryRunner.java:103)
	at io.druid.query.MetricsEmittingQueryRunner$1.accumulate(MetricsEmittingQueryRunner.java:103)
	at io.druid.query.spec.SpecificSegmentQueryRunner$2$1.call(SpecificSegmentQueryRunner.java:78)
	at io.druid.query.spec.SpecificSegmentQueryRunner.doNamed(SpecificSegmentQueryRunner.java:149)
	at io.druid.query.spec.SpecificSegmentQueryRunner.access$300(SpecificSegmentQueryRunner.java:35)
	at io.druid.query.spec.SpecificSegmentQueryRunner$2.doItNamed(SpecificSegmentQueryRunner.java:140)
	at io.druid.query.spec.SpecificSegmentQueryRunner$2.accumulate(SpecificSegmentQueryRunner.java:72)
	at com.metamx.common.guava.Sequences.toList(Sequences.java:113)
	at io.druid.query.ChainedExecutionQueryRunner$1$1$1.call(ChainedExecutionQueryRunner.java:132)
	at io.druid.query.ChainedExecutionQueryRunner$1$1$1.call(ChainedExecutionQueryRunner.java:118)
	at java.util.concurrent.FutureTask.run(FutureTask.java:262)
	at io.druid.query.PrioritizedExecutorService$PrioritizedListenableFutureTask.run(PrioritizedExecutorService.java:204)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
	at java.lang.Thread.run(Thread.java:745)
2014-10-29 21:40:59,199 ERROR [processing-5] io.druid.query.ChainedExecutionQueryRunner - Exception with one of the sequences!
java.lang.NullPointerException
	at io.druid.query.topn.PooledTopNAlgorithm.cleanup(PooledTopNAlgorithm.java:231)
	at io.druid.query.topn.PooledTopNAlgorithm.cleanup(PooledTopNAlgorithm.java:37)
	at io.druid.query.topn.TopNMapFn.apply(TopNMapFn.java:64)
	at io.druid.query.topn.TopNMapFn.apply(TopNMapFn.java:29)
	at io.druid.query.topn.TopNQueryEngine$1.apply(TopNQueryEngine.java:84)
	at io.druid.query.topn.TopNQueryEngine$1.apply(TopNQueryEngine.java:79)
	at com.metamx.common.guava.MappingYieldingAccumulator.accumulate(MappingYieldingAccumulator.java:57)
	at com.metamx.common.guava.FilteringYieldingAccumulator.accumulate(FilteringYieldingAccumulator.java:69)
	at com.metamx.common.guava.MappingYieldingAccumulator.accumulate(MappingYieldingAccumulator.java:57)
	at com.metamx.common.guava.BaseSequence.makeYielder(BaseSequence.java:104)
	at com.metamx.common.guava.BaseSequence.toYielder(BaseSequence.java:81)
	at com.metamx.common.guava.MappedSequence.toYielder(MappedSequence.java:46)
	at com.metamx.common.guava.ResourceClosingSequence.toYielder(ResourceClosingSequence.java:25)
	at com.metamx.common.guava.FilteredSequence.toYielder(FilteredSequence.java:52)
	at com.metamx.common.guava.MappedSequence.toYielder(MappedSequence.java:46)
	at com.metamx.common.guava.FilteredSequence.toYielder(FilteredSequence.java:52)
	at com.metamx.common.guava.ResourceClosingSequence.toYielder(ResourceClosingSequence.java:25)
	at com.metamx.common.guava.YieldingSequenceBase.accumulate(YieldingSequenceBase.java:18)
	at io.druid.query.MetricsEmittingQueryRunner$1.accumulate(MetricsEmittingQueryRunner.java:103)
	at io.druid.query.MetricsEmittingQueryRunner$1.accumulate(MetricsEmittingQueryRunner.java:103)
	at io.druid.query.spec.SpecificSegmentQueryRunner$2$1.call(SpecificSegmentQueryRunner.java:78)
	at io.druid.query.spec.SpecificSegmentQueryRunner.doNamed(SpecificSegmentQueryRunner.java:149)
	at io.druid.query.spec.SpecificSegmentQueryRunner.access$300(SpecificSegmentQueryRunner.java:35)
	at io.druid.query.spec.SpecificSegmentQueryRunner$2.doItNamed(SpecificSegmentQueryRunner.java:140)
	at io.druid.query.spec.SpecificSegmentQueryRunner$2.accumulate(SpecificSegmentQueryRunner.java:72)
	at com.metamx.common.guava.Sequences.toList(Sequences.java:113)
	at io.druid.query.ChainedExecutionQueryRunner$1$1$1.call(ChainedExecutionQueryRunner.java:132)
	at io.druid.query.ChainedExecutionQueryRunner$1$1$1.call(ChainedExecutionQueryRunner.java:118)
	at java.util.concurrent.FutureTask.run(FutureTask.java:262)
	at io.druid.query.PrioritizedExecutorService$PrioritizedListenableFutureTask.run(PrioritizedExecutorService.java:204)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
	at java.lang.Thread.run(Thread.java:745)
2014-10-29 21:40:59,207 INFO [topN_click_conversion_[2014-07-24T00:00:00.000Z/2014-07-25T00:00:00.000Z]] io.druid.guice.DruidProcessingModule$IntermediateProcessingBufferPool - Allocating new intermediate processing buffer[223] of size[1,142,857,142]
2014-10-29 21:40:59,207 INFO [topN_click_conversion_[2014-06-04T00:00:00.000Z/2014-06-05T00:00:00.000Z]] io.druid.guice.DruidProcessingModule$IntermediateProcessingBufferPool - Allocating new intermediate processing buffer[224] of size[1,142,857,142]
[Full GC[CMS: 15444K->15262K(3145728K), 0.0890440 secs] 44207K->15262K(4089472K), [CMS Perm : 39889K->39889K(66556K)], 0.0891450 secs] [Times: user=0.09 sys=0.00, real=0.09 secs] 
[Full GC[CMS: 15262K->15247K(3145728K), 0.0889730 secs] 22454K->15247K(4089472K), [CMS Perm : 39889K->39889K(66556K)], 0.0890760 secs] [Times: user=0.09 sys=0.00, real=0.08 secs] 
2014-10-29 21:40:59,386 ERROR [processing-1] io.druid.query.ChainedExecutionQueryRunner - Exception with one of the sequences!
java.lang.NullPointerException
	at io.druid.query.topn.PooledTopNAlgorithm.cleanup(PooledTopNAlgorithm.java:231)
	at io.druid.query.topn.PooledTopNAlgorithm.cleanup(PooledTopNAlgorithm.java:37)
	at io.druid.query.topn.TopNMapFn.apply(TopNMapFn.java:64)
	at io.druid.query.topn.TopNMapFn.apply(TopNMapFn.java:29)
	at io.druid.query.topn.TopNQueryEngine$1.apply(TopNQueryEngine.java:84)
	at io.druid.query.topn.TopNQueryEngine$1.apply(TopNQueryEngine.java:79)
	at com.metamx.common.guava.MappingYieldingAccumulator.accumulate(MappingYieldingAccumulator.java:57)
	at com.metamx.common.guava.FilteringYieldingAccumulator.accumulate(FilteringYieldingAccumulator.java:69)
	at com.metamx.common.guava.MappingYieldingAccumulator.accumulate(MappingYieldingAccumulator.java:57)
	at com.metamx.common.guava.BaseSequence.makeYielder(BaseSequence.java:104)
	at com.metamx.common.guava.BaseSequence.toYielder(BaseSequence.java:81)
	at com.metamx.common.guava.MappedSequence.toYielder(MappedSequence.java:46)
	at com.metamx.common.guava.ResourceClosingSequence.toYielder(ResourceClosingSequence.java:25)
	at com.metamx.common.guava.FilteredSequence.toYielder(FilteredSequence.java:52)
	at com.metamx.common.guava.MappedSequence.toYielder(MappedSequence.java:46)
	at com.metamx.common.guava.FilteredSequence.toYielder(FilteredSequence.java:52)
	at com.metamx.common.guava.ResourceClosingSequence.toYielder(ResourceClosingSequence.java:25)
	at com.metamx.common.guava.YieldingSequenceBase.accumulate(YieldingSequenceBase.java:18)
	at io.druid.query.MetricsEmittingQueryRunner$1.accumulate(MetricsEmittingQueryRunner.java:103)
	at io.druid.query.MetricsEmittingQueryRunner$1.accumulate(MetricsEmittingQueryRunner.java:103)
	at io.druid.query.spec.SpecificSegmentQueryRunner$2$1.call(SpecificSegmentQueryRunner.java:78)
	at io.druid.query.spec.SpecificSegmentQueryRunner.doNamed(SpecificSegmentQueryRunner.java:149)
	at io.druid.query.spec.SpecificSegmentQueryRunner.access$300(SpecificSegmentQueryRunner.java:35)
	at io.druid.query.spec.SpecificSegmentQueryRunner$2.doItNamed(SpecificSegmentQueryRunner.java:140)
	at io.druid.query.spec.SpecificSegmentQueryRunner$2.accumulate(SpecificSegmentQueryRunner.java:72)
	at com.metamx.common.guava.Sequences.toList(Sequences.java:113)
	at io.druid.query.ChainedExecutionQueryRunner$1$1$1.call(ChainedExecutionQueryRunner.java:132)
	at io.druid.query.ChainedExecutionQueryRunner$1$1$1.call(ChainedExecutionQueryRunner.java:118)
	at java.util.concurrent.FutureTask.run(FutureTask.java:262)
	at io.druid.query.PrioritizedExecutorService$PrioritizedListenableFutureTask.run(PrioritizedExecutorService.java:204)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
	at java.lang.Thread.run(Thread.java:745)
2014-10-29 21:40:59,386 ERROR [processing-4] io.druid.query.ChainedExecutionQueryRunner - Exception with one of the sequences!
java.lang.NullPointerException
	at io.druid.query.topn.PooledTopNAlgorithm.cleanup(PooledTopNAlgorithm.java:231)
	at io.druid.query.topn.PooledTopNAlgorithm.cleanup(PooledTopNAlgorithm.java:37)
	at io.druid.query.topn.TopNMapFn.apply(TopNMapFn.java:64)
	at io.druid.query.topn.TopNMapFn.apply(TopNMapFn.java:29)
	at io.druid.query.topn.TopNQueryEngine$1.apply(TopNQueryEngine.java:84)
	at io.druid.query.topn.TopNQueryEngine$1.apply(TopNQueryEngine.java:79)
	at com.metamx.common.guava.MappingYieldingAccumulator.accumulate(MappingYieldingAccumulator.java:57)
	at com.metamx.common.guava.FilteringYieldingAccumulator.accumulate(FilteringYieldingAccumulator.java:69)
	at com.metamx.common.guava.MappingYieldingAccumulator.accumulate(MappingYieldingAccumulator.java:57)
	at com.metamx.common.guava.BaseSequence.makeYielder(BaseSequence.java:104)
	at com.metamx.common.guava.BaseSequence.toYielder(BaseSequence.java:81)
	at com.metamx.common.guava.MappedSequence.toYielder(MappedSequence.java:46)
	at com.metamx.common.guava.ResourceClosingSequence.toYielder(ResourceClosingSequence.java:25)
	at com.metamx.common.guava.FilteredSequence.toYielder(FilteredSequence.java:52)
	at com.metamx.common.guava.MappedSequence.toYielder(MappedSequence.java:46)
	at com.metamx.common.guava.FilteredSequence.toYielder(FilteredSequence.java:52)
	at com.metamx.common.guava.ResourceClosingSequence.toYielder(ResourceClosingSequence.java:25)
	at com.metamx.common.guava.YieldingSequenceBase.accumulate(YieldingSequenceBase.java:18)
	at io.druid.query.MetricsEmittingQueryRunner$1.accumulate(MetricsEmittingQueryRunner.java:103)
	at io.druid.query.MetricsEmittingQueryRunner$1.accumulate(MetricsEmittingQueryRunner.java:103)
	at io.druid.query.spec.SpecificSegmentQueryRunner$2$1.call(SpecificSegmentQueryRunner.java:78)
	at io.druid.query.spec.SpecificSegmentQueryRunner.doNamed(SpecificSegmentQueryRunner.java:149)
	at io.druid.query.spec.SpecificSegmentQueryRunner.access$300(SpecificSegmentQueryRunner.java:35)
	at io.druid.query.spec.SpecificSegmentQueryRunner$2.doItNamed(SpecificSegmentQueryRunner.java:140)
	at io.druid.query.spec.SpecificSegmentQueryRunner$2.accumulate(SpecificSegmentQueryRunner.java:72)
	at com.metamx.common.guava.Sequences.toList(Sequences.java:113)
	at io.druid.query.ChainedExecutionQueryRunner$1$1$1.call(ChainedExecutionQueryRunner.java:132)
	at io.druid.query.ChainedExecutionQueryRunner$1$1$1.call(ChainedExecutionQueryRunner.java:118)
	at java.util.concurrent.FutureTask.run(FutureTask.java:262)
	at io.druid.query.PrioritizedExecutorService$PrioritizedListenableFutureTask.run(PrioritizedExecutorService.java:204)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
	at java.lang.Thread.run(Thread.java:745)
```

The above lines repeat hundreds of times in the log.

Coordinator Console Problems
---

The Coordniator Console looks like this:
![alt tag](https://raw.github.com/lexicalunit/druid_config/master/images/console.png)

When I go to `http://coordinator-ip:8080`, the Coordinator Console comes up and works perfectly. For example, the dropdowns are properly populated:
![alt tag](https://raw.github.com/lexicalunit/druid_config/master/images/working_console.png)

However, when I go to, for example, `http://overlord-ip:8080` instead, the console will come up but nothing works properly. For example, dropdowns not working anymore:
![alt tag](https://raw.github.com/lexicalunit/druid_config/master/images/broken_console.png)

Resolved Issues
===

No Task Logs
---
After kicking off a Indexing Task I can see that it is running in the console:
![alt tag](https://raw.github.com/lexicalunit/druid_config/master/images/task_running.png)

Eventually, the task fails:
![alt tag](https://raw.github.com/lexicalunit/druid_config/master/images/task_fail.png)

When I click on the link `log (all)` I am taken to a page that just says:

```
No log was found for this task. The task may not exist, or it may not have begun running yet.
```

Given the following properties in my overlord configuration:

```properties
druid.indexer.logs.type=s3
druid.indexer.logs.s3Bucket=s3-bucket
druid.indexer.logs.s3Prefix=logs
```

And the following properties in my middleManager configuration:

```properties
druid.selectors.indexing.serviceName=druid:overlord
```

The logs should be available on S3, however they are not:

```bash
$ s3cmd ls s3://s3-bucket/
	DIR   s3://s3-bucket/click_conversion/
	DIR   s3://s3-bucket/click_conversion_weekly/
```

### Resolution

The following needed to be added to the middleManager configuration:

```properties
druid.indexer.logs.type=s3
druid.indexer.logs.s3Bucket=s3-bucket
druid.indexer.logs.s3Prefix=logs
```

Index Task Fails
---
I am trying to reindex my `click_conversion` dataset so that segments are indexed by `WEEK` rather than by `DAY`.

### Index Task Description

Here is my indexing task specification:

```json
{
    "type": "index",
    "dataSource": "click_conversion_weekly",
    "granularitySpec":
    {
        "type": "uniform",
        "gran": "WEEK",
        "intervals": ["2014-04-06T00:00:00.000Z/2014-04-13T00:00:00.000Z"]
    },
    "indexGranularity": "minute",
    "aggregators": [
        {"type": "count", "name": "count"},
        {"type": "doubleSum", "name": "commissions", "fieldName": "commissions"},
        {"type": "doubleSum", "name": "sales", "fieldName": "sales"},
        {"type": "doubleSum", "name": "orders", "fieldName": "orders"}
    ],
    "firehose": {
        "type": "ingestSegment",
        "dataSource": "click_conversion",
        "interval": "2014-04-06T00:00:00.000Z/2014-04-13T00:00:00.000Z"
    }
}
```

### Index Task Error

The task eventually fails with the following error:

```
2014-10-27 16:40:11,934 INFO [task-runner-0] io.druid.indexing.common.actions.RemoteTaskActionClient - Submitting action for task[reingest] to overlord[http://10.13.132.213:8080/druid/indexer/v1/action]: SegmentListUsedAction{dataSource='click_conversion', interval=2014-04-06T00:00:00.000Z/2014-04-13T00:00:00.000Z}
2014-10-27 16:40:50,224 WARN [task-runner-0] io.druid.indexing.common.index.YeOldePlumberSchool - Failed to merge and upload
java.lang.IllegalStateException: Nothing indexed?
	at io.druid.indexing.common.index.YeOldePlumberSchool$1.finishJob(YeOldePlumberSchool.java:159)
	at io.druid.indexing.common.task.IndexTask.generateSegment(IndexTask.java:444)
	at io.druid.indexing.common.task.IndexTask.run(IndexTask.java:198)
	at io.druid.indexing.overlord.ThreadPoolTaskRunner$ThreadPoolTaskRunnerCallable.call(ThreadPoolTaskRunner.java:219)
	at io.druid.indexing.overlord.ThreadPoolTaskRunner$ThreadPoolTaskRunnerCallable.call(ThreadPoolTaskRunner.java:198)
	at java.util.concurrent.FutureTask.run(FutureTask.java:262)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
	at java.lang.Thread.run(Thread.java:745)
2014-10-27 16:40:50,228 INFO [task-runner-0] io.druid.indexing.common.task.IndexTask - Task[index_click_conversion_weekly_2014-10-27T16:36:15.336Z] interval[2014-04-07T00:00:00.000Z/2014-04-14T00:00:00.000Z] partition[0] took in 12,968,203 rows (0 processed, 0 unparseable, 12,968,203 thrown away) and output 0 rows
2014-10-27 16:40:50,229 ERROR [task-runner-0] io.druid.indexing.overlord.ThreadPoolTaskRunner - Exception while running task[IndexTask{id=index_click_conversion_weekly_2014-10-27T16:36:15.336Z, type=index, dataSource=click_conversion_weekly}]
java.lang.IllegalStateException: Nothing indexed?
	at io.druid.indexing.common.index.YeOldePlumberSchool$1.finishJob(YeOldePlumberSchool.java:159)
	at io.druid.indexing.common.task.IndexTask.generateSegment(IndexTask.java:444)
	at io.druid.indexing.common.task.IndexTask.run(IndexTask.java:198)
	at io.druid.indexing.overlord.ThreadPoolTaskRunner$ThreadPoolTaskRunnerCallable.call(ThreadPoolTaskRunner.java:219)
	at io.druid.indexing.overlord.ThreadPoolTaskRunner$ThreadPoolTaskRunnerCallable.call(ThreadPoolTaskRunner.java:198)
	at java.util.concurrent.FutureTask.run(FutureTask.java:262)
	at java.util.concurrent.ThreadPoolExecutor.runWorker(ThreadPoolExecutor.java:1145)
	at java.util.concurrent.ThreadPoolExecutor$Worker.run(ThreadPoolExecutor.java:615)
	at java.lang.Thread.run(Thread.java:745)
2014-10-27 16:40:50,229 INFO [task-runner-0] io.druid.indexing.overlord.ThreadPoolTaskRunner - Removing task directory: /tmp/persistent/task/index_click_conversion_weekly_2014-10-27T16:36:15.336Z/work
2014-10-27 16:40:50,242 INFO [task-runner-0] io.druid.indexing.worker.executor.ExecutorLifecycle - Task completed with status: {
  "id" : "index_click_conversion_weekly_2014-10-27T16:36:15.336Z",
  "status" : "FAILED",
  "duration" : 268865
}
2014-10-27 16:40:50,248 INFO [main] com.metamx.common.lifecycle.Lifecycle$AnnotationBasedHandler - Invoking stop method[public void io.druid.server.coordination.AbstractDataSegmentAnnouncer.stop()] on object[io.druid.server.coordination.BatchDataSegmentAnnouncer@47f36a24].
```

Please see the full log for details: [task.log](task.log).

### Index Task Overlord Log

And here is what the overlord log shows:

```
2014-10-27 16:40:11,761 INFO [qtp1352013222-38] io.druid.indexing.common.actions.LocalTaskActionClient - Performing action for task[reingest]: SegmentListUsedAction{dataSource='click_conversion', interval=2014-04-06T00:00:00.000Z/2014-04-13T00:00:00.000Z}
2014-10-27 16:40:28,849 INFO [TaskQueue-StorageSync] io.druid.indexing.overlord.TaskQueue - Synced 1 tasks from storage (0 tasks added, 0 tasks removed).
2014-10-27 16:40:50,822 INFO [PathChildrenCache-0] io.druid.indexing.overlord.RemoteTaskRunner - Worker[10.136.64.60:8080] wrote FAILED status for task: index_click_conversion_weekly_2014-10-27T16:36:15.336Z
2014-10-27 16:40:50,822 INFO [PathChildrenCache-0] io.druid.indexing.overlord.RemoteTaskRunner - Worker[10.136.64.60:8080] completed task[index_click_conversion_weekly_2014-10-27T16:36:15.336Z] with status[FAILED]
2014-10-27 16:40:50,822 INFO [PathChildrenCache-0] io.druid.indexing.overlord.TaskQueue - Received FAILED status for task: index_click_conversion_weekly_2014-10-27T16:36:15.336Z
2014-10-27 16:40:50,823 INFO [PathChildrenCache-0] io.druid.indexing.overlord.RemoteTaskRunner - Cleaning up task[index_click_conversion_weekly_2014-10-27T16:36:15.336Z] on worker[10.136.64.60:8080]
2014-10-27 16:40:50,826 INFO [PathChildrenCache-0] io.druid.indexing.overlord.HeapMemoryTaskStorage - Updating task index_click_conversion_weekly_2014-10-27T16:36:15.336Z to status: TaskStatus{id=index_click_conversion_weekly_2014-10-27T16:36:15.336Z, status=FAILED, duration=0}
2014-10-27 16:40:50,826 INFO [PathChildrenCache-0] io.druid.indexing.overlord.TaskLockbox - Removing task[index_click_conversion_weekly_2014-10-27T16:36:15.336Z] from TaskLock[index_click_conversion_weekly_2014-10-27T16:36:15.336Z]
2014-10-27 16:40:50,826 INFO [PathChildrenCache-0] io.druid.indexing.overlord.TaskLockbox - TaskLock is now empty: TaskLock{groupId=index_click_conversion_weekly_2014-10-27T16:36:15.336Z, dataSource=click_conversion_weekly, interval=2014-03-31T00:00:00.000Z/2014-04-14T00:00:00.000Z, version=2014-10-27T16:36:15.337Z}
2014-10-27 16:40:50,826 INFO [PathChildrenCache-0] io.druid.indexing.overlord.TaskQueue - Task done: IndexTask{id=index_click_conversion_weekly_2014-10-27T16:36:15.336Z, type=index, dataSource=click_conversion_weekly}
2014-10-27 16:40:50,827 INFO [PathChildrenCache-0] io.druid.indexing.overlord.TaskQueue - Task FAILED: IndexTask{id=index_click_conversion_weekly_2014-10-27T16:36:15.336Z, type=index, dataSource=click_conversion_weekly} (0 run duration)
2014-10-27 16:40:50,827 INFO [PathChildrenCache-0] io.druid.indexing.overlord.RemoteTaskRunner - Task[index_click_conversion_weekly_2014-10-27T16:36:15.336Z] went bye bye.
2014-10-27 16:41:28,849 INFO [TaskQueue-StorageSync] io.druid.indexing.overlord.TaskQueue - Synced 0 tasks from storage (0 tasks added, 0 tasks removed).
2014-10-27 16:42:28,850 INFO [TaskQueue-StorageSync] io.druid.indexing.overlord.TaskQueue - Synced 0 tasks from storage (0 tasks added, 0 tasks removed).
```

### Resolution

I had to workaround a bug that the druid devs found in the indexing service by specifying directly the `numShards` property in the task JSON. This is the replacement task JSON:

```json
{
  "type" : "index",
  "schema" : {
    "dataSchema" : {
      "dataSource" : "click_conversion_weekly",
      "metricsSpec" : [ {
        "type" : "count",
        "name" : "count"
      }, {
        "type" : "doubleSum",
        "name" : "commissions",
        "fieldName" : "commissions"
      }, {
        "type" : "doubleSum",
        "name" : "sales",
        "fieldName" : "sales"
      }, {
        "type" : "doubleSum",
        "name" : "orders",
        "fieldName" : "orders"
      } ],
      "granularitySpec" : {
        "type" : "uniform",
        "segmentGranularity" : "WEEK",
        "queryGranularity" : "MINUTE",
        "intervals" : [ "2014-04-13T00:00:00.000Z/2014-09-01T00:00:00.000Z" ]
      }
    },
    "ioConfig" : {
      "type" : "index",
      "firehose" : {
        "type" : "ingestSegment",
        "dataSource" : "click_conversion",
        "interval" : "2014-04-13T00:00:00.000Z/2014-09-01T00:00:00.000Z"
      }
    },
    "tuningConfig" : {
      "type" : "index",
      "rowFlushBoundary" : 500000,
      "targetPartitionSize": -1,
      "numShards" : 3
    }
  }
}
```

I also needed to mount an EBS volume on the middle manager node and add the following configuration to the middle manager node:

```properties
druid.indexer.runner.javaOpts="-server -Xmx2g -XX:+UseG1GC -XX:MaxGCPauseMillis=100 -XX:+PrintGCDetails -XX:+PrintGCTimeStamps"
druid.indexer.task.chathandler.type=announce
druid.indexer.task.baseTaskDir=/persistent
```