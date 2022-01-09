# Axon Framework Resource Reference Doc
This document is a collation of resources for understanding actual practical usage of the Axon Framework:
- Feel free to:
    - use it to lookup something (code snippets/examples/tips).
    - contribute a change if something is wrong or missing.
    - fork it and make a better/derivative version.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Contents**

- [Project Structure (Start Here)](#project-structure-start-here)
- [Open Source Example Projects](#open-source-example-projects)
- [Examples of testing](#examples-of-testing)
- [`@Aggregate` Tips](#aggregate-tips)
  - [Creating an `@Aggregate`](#creating-an-aggregate)
    - [From another aggregate (using `AggregateLifecycle.createNew(Class<T>, Callable<T>)`)](#from-another-aggregate-using-aggregatelifecyclecreatenewclasst-callablet)
- [`@Repository<T>` Tips](#repositoryt-tips)
  - [Autowiring a `@Repository<T>`](#autowiring-a-repositoryt)
  - [Manually creating a `@Repository<T>` bean](#manually-creating-a-repositoryt-bean)
    - [Backed by an `EventStore` repository](#backed-by-an-eventstore-repository)
- [Examples of snapshotting](#examples-of-snapshotting)
  - [idugalic/digital-restaurant](#idugalicdigital-restaurant)
- [Tracking Event Processor](#tracking-event-processor)
  - [Configuring properties](#configuring-properties)
  - [Resetting a tracking event processor](#resetting-a-tracking-event-processor)
- [Subscription Queries](#subscription-queries)
  - [Videos](#videos)
  - [Example Code](#example-code)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

# Project Structure (Start Here)

See:
1. The [quick start application](https://github.com/AxonIQ/axon-quick-start/blob/master/chat-scaling-out/src/test/java/io/axoniq/labs/chat/commandmodel/ChatRoomTest.java).
   - It is based on Axon 3 but the API is more or less the same for Axon 4.
   - Gives you a solid base in which you can learn:
      - The typical Axon CQRS project structure.
      - Axon Framework APIs (`@CommandHandler`, `@EventSourcingHandler`, `@EventHandler`, `@QueryHandler`, etc).
      - *Important*: How to test your application (see [test suite](https://github.com/AxonIQ/axon-quick-start/blob/master/chat-scaling-out/src/test/java/io/axoniq/labs/chat/commandmodel/ChatRoomTest.java)).
2. The [associated Webinar](https://www.youtube.com/watch?v=IhLSwCRyrcw)
   - Ideal to watch at 1.5x/2x speed.
   - A good walkthrough of the structure.

# Open Source Example Projects

- [nklmish/axon-casino](https://github.com/nklmish/axon-casino)
  - Kotlin, Axon 3
- [idugalic/axon-contract-testing-demo](https://github.com/idugalic/axon-contract-testing-demo)
  - Java 8, Axon 4
  - Demo - Axon - Bounded contexts - Saga pattern - Contract testing
  - https://idugalic.github.io/axon-contract-testing-demo/
- [idugalic/axon-polymorphism-demo](https://github.com/idugalic/axon-polymorphism-demo)
  - Java 8, Axon 4
  - Axon and OOP (Inheritance, Polymorphism)
- [AxonIQ/axon-quick-start](https://github.com/AxonIQ/axon-quick-start)
  - Java 8, Axon 4
  - Repository containing some base code and guidelines to build and then scale an application
- [idugalic/axon-scale-demo](https://github.com/idugalic/axon-scale-demo)
  - Java 8, Axon 4
  - Axon (Spring Boot) demo application - Deploy to Kubernetes via Docker Stack API and/or `kubectl` and `skaffold` - Scale out
  - https://idugalic.github.io/axon-scale-demo/
- [gushakov/axon-simple](https://github.com/gushakov/axon-simple)
  - Java 8, Axon 4
  - Simple CQRS application using Axon without Event Sourcing
- [idugalic/axon-statemachine-demo](https://github.com/idugalic/axon-statemachine-demo)
  - Java 8, Axon 4
  - This demo application demonstrate the usage of inheritance and polymorphism for making the concept of the finite state machine more explicit in your design.
- [fransvanbuul/axon-sync-rest-frontend](https://github.com/fransvanbuul/axon-sync-rest-frontend)
  - Java 8, Axon 3
  - Small example illustrating how to create a synchronous REST front-end on an asynchronous CQRS+ES back-end using Axon's subscription queries.
- [AxonFramework/Axon-trader](https://github.com/AxonFramework/Axon-trader/)
  - Java 8, Axon 3
  - Sample application to demonstrate the possibilities of the Axon framework in a high load environment.
- [AxonFramework/AxonBank](https://github.com/AxonFramework/AxonBank)
  - Java 8, Axon 3
  - This is a sample application with the purpose of showing the capabilities of Axon Framework.
- [AxonIQ/conference-demo-bike-rental](https://github.com/AxonIQ/conference-demo-bike-rental)
  - Java 8, Axon 3
- Digital Restaurant:
  - [idugalic/digital-restaurant](https://github.com/idugalic/digital-restaurant)
    - Kotlin, Axon 4
  - [idugalic/digital-restaurant-angular](https://github.com/idugalic/digital-restaurant-angular)
    - It is a front-end part of a 'Restaurant Food To Go' solution. It consumes REST API provided by https://github.com/idugalic/digital-restaurant/drestaurant-apps/drestaurant-monolith
- [haschi/dominium](https://github.com/haschi/dominium)
  - Kotlin, Axon 3
  - Accounting system for households. A playground to practice Domain Driven Design and CQRS / ES with Axon Framework
- [AxonIQ/food-ordering-demo](https://github.com/AxonIQ/food-ordering-demo)
  - Java 8, Axon 4
  - Demo application focusing on the Food Ordering domain - Used in our video series
- [AxonIQ/giftcard-demo](https://github.com/AxonIQ/giftcard-demo)
  - Java 11, Axon 4
  - This Axon Framework demo application focuses around a simple giftcard domain, designed to show various aspects of the framework.
- [AxonIQ/hotel-demo](https://github.com/AxonIQ/hotel-demo)
  - Java 11, Axon 4
  - It's the implementation of the example used in this blog post: https://eventmodeling.org/posts/what-is-event-modeling/
- [croz-ltd/klokwrk-project](https://github.com/croz-ltd/klokwrk-project)
  - Groovy, Axon
  - https://croz.net/news/introducing-project-klokwrk/
- [idugalic/micro-company](https://github.com/idugalic/micro-company)
  - Java 8, Axon 3
  - Intended to demonstrate end-to-end best practices for building a cloud native, event driven microservice architecture using Spring Cloud and Axon
- [idugalic/axon-vanilla-java-demo](https://github.com/idugalic/axon-vanilla-java-demo)
  - Java 8, Axon 4
  - Demonstrates use of Axon (vanilla Java) Configuration API with Axon Server.
- [matty-matt/movie-keeper-core](https://github.com/matty-matt/movie-keeper-core)
  - Java 11, Axon 4
  - Backend for [MovieKeeper](https://github.com/TheMickeyMike/MovieKeeper) React application that allows storing movies you'd like to watch. Digital release dates of your stored movies are tracked by app.
- [AxonIQ/running-axon-server](https://github.com/AxonIQ/running-axon-server)
  - The files that go with the "Running Axon Server" Blog series:
    - [Running Axon Server - Full featured cluster in the cloud](https://axoniq.io/blog-overview/running-axon-server)
    - [Running Axon Server in Docker](https://axoniq.io/blog-overview/running-axon-server-in-docker)
    - [Running Axon Server in a Virtual Machine](https://axoniq.io/blog-overview/running-axon-server-in-a-virtual-machine)
- [AxonIQ/code-samples](https://github.com/AxonIQ/code-samples)
  - Contains a number of subprojects with each subproject showcasing example code for a specific scenario:
    - axon-spring-template
    - distributed-exceptions
    - reset-handler
    - saga
    - sequencing-policy
    - set-based-validation
    - subscription-query-rest
    - subscription-query-ui-streaming
    - upcaster
- [JohT/showcase-quarkus-eventsourcing](https://github.com/JohT/showcase-quarkus-eventsourcing)
  - Java 11, Axon 4
  - Shows an example on how to use axon in conjunction with microprofile on quarkus
- [fransvanbuul/sq-webinar](https://github.com/fransvanbuul/sq-webinar/)
  - Java 8, Axon 3
  - Repository of the live code webinar on subscription queries - 24 July 2018
  - [Introducing Subscription Queries - AxonIQ Webinar](https://www.youtube.com/watch?v=b3NLDxa6MWE)
- [abuijze/webinar-axon-bank](https://github.com/abuijze/webinar-axon-bank)
  - Java 8, Axon 3


# Examples of testing

- Unit Testing an `@Aggregate`:
  - [ChatRoomTest.java](https://github.com/AxonIQ/axon-quick-start/blob/master/chat-scaling-out/src/test/java/io/axoniq/labs/chat/commandmodel/ChatRoomTest.java)


# `@Aggregate` Tips

## Creating an `@Aggregate`

### From another aggregate (using `AggregateLifecycle.createNew(Class<T>, Callable<T>)`)

See:
- [reference documentation](https://docs.axoniq.io/reference-guide/v/4.5/axon-framework/axon-framework-commands/modeling/aggregate-creation-from-another-aggregate)


# `@Repository<T>` Tips

Occasionally, we need to write a `@Component` which has access to an underlying Axon `Repository<T>`.
- Sometimes dealing with a `@Repository<T>` can be slightly annoying (I think it is because of the generic type `<T>`).
- Follow the tips in the code snippets below when you have a problem.

## Autowiring a `@Repository<T>`

- You need to add a `@Lazy` to the parameter in the constructor in your `@Component` (assuming constructor injection and all final fields).
- If you do not do this your application context may fail to load because of an NPE.

## Manually creating a `@Repository<T>` bean

### Backed by an `EventStore` repository

```java
  @Bean
  public Repository<GiftCard> giftCardRepository(EventStore eventStore, Cache cache) {
      return EventSourcingRepository.builder(GiftCard.class)
                                    .cache(cache)
                                    .eventStore(eventStore)
                                    .build();
  }
```

For original code source, see: [giftcard-demo](https://github.com/AxonIQ/giftcard-demo/blob/af76b5c4b9ba8623b12108bfc9060fe1df58cce9/src/main/java/io/axoniq/demo/giftcard/command/GcCommandConfiguration.java).


# Examples of snapshotting

##  [idugalic/digital-restaurant](https://github.com/idugalic/digital-restaurant#snapshoting)

The digital restaurant application contains examples of how to define snapshotting for your aggregates From the [README](https://github.com/idugalic/digital-restaurant#snapshoting):

    A Snapshot is a denormalization of the current state of an aggregate at a given point in time
    It represents the state when all events to that point in time have been replayed
    They are used as a heuristic to prevent the need to load all events for the entire history of an aggregate

Each aggregate defines a snapshot trigger:

    @Aggregate(snapshotTriggerDefinition = "courierSnapshotTriggerDefinition")
    Feel free to configure a treshold (number of events) that should trigger the snapshot creation. This treshold is externalized as a property axon.snapshot.trigger.treshold.courier

- `Courier` `@Aggregate`:
   - [`@Aggregate` definition](https://github.com/idugalic/digital-restaurant/blob/master/drestaurant-libs/drestaurant-courier/src/main/kotlin/com/drestaurant/courier/domain/Courier.kt)
   - [courierSnapshotTriggerDefinition (`@Bean`)](https://github.com/idugalic/digital-restaurant/blob/master/drestaurant-libs/drestaurant-courier/src/main/kotlin/com/drestaurant/courier/domain/SpringCourierConfiguration.kt)
- `CourierOrder` `@Aggregate`:
  - [`@Aggregate` definition](https://github.com/idugalic/digital-restaurant/blob/master/drestaurant-libs/drestaurant-courier/src/main/kotlin/com/drestaurant/courier/domain/CourierOrder.kt)
  - [courierOrderSnapshotTriggerDefinition (`@Bean`)](https://github.com/idugalic/digital-restaurant/blob/master/drestaurant-libs/drestaurant-courier/src/main/kotlin/com/drestaurant/courier/domain/SpringCourierConfiguration.kt)
- `Customer` `@Aggregate`:
  - [`@Aggregate` definition](https://github.com/idugalic/digital-restaurant/blob/master/drestaurant-libs/drestaurant-customer/src/main/kotlin/com/drestaurant/customer/domain/Customer.kt)
  - [customerSnapshotTriggerDefinition (`@Bean`)](https://github.com/idugalic/digital-restaurant/blob/master/drestaurant-libs/drestaurant-customer/src/main/kotlin/com/drestaurant/customer/domain/SpringCustomerConfiguration.kt)
- `CustomerOrder` `@Aggregate`:
  - [`@Aggregate` definition](https://github.com/idugalic/digital-restaurant/blob/master/drestaurant-libs/drestaurant-customer/src/main/kotlin/com/drestaurant/customer/domain/CustomerOrder.kt)
  - [customerOrderSnapshotTriggerDefinition (`@Bean`)](https://github.com/idugalic/digital-restaurant/blob/master/drestaurant-libs/drestaurant-customer/src/main/kotlin/com/drestaurant/customer/domain/SpringCustomerConfiguration.kt)

# Tracking Event Processor

## Configuring properties

Examples of configuring tracking event processors:

See:
- [idugalic/axon-scale-demo](https://github.com/idugalic/axon-scale-demo):
  - [GiftCardHandler `@Component` (`@ProcessingGroup("giftcardprocessor")`)](https://github.com/idugalic/axon-scale-demo/blob/master/src/main/java/com/demo/query/GiftCardHandler.java)
  - [application.properties](https://github.com/idugalic/axon-scale-demo/blob/master/src/main/resources/application.properties)
     - We set `mode=tracking`, `initial-segment-count=4`, `thread-count=4`

## Resetting a tracking event processor

See:
- https://github.com/idugalic/digital-restaurant/blob/b9fa7ad168be418456b1815172d45bd508388479/drestaurant-apps/drestaurant-monolith-rest/src/main/kotlin/com/drestaurant/admin/AxonAdministration.kt


# Subscription Queries

## Videos

- [Introducing Subscription Queries - AxonIQ Webinar](https://www.youtube.com/watch?v=b3NLDxa6MWE)

## Example Code
(Kotlin) [nklmish/axon-casino](https://github.com/nklmish/axon-casino/tree/019d14c1cd25972fb4a48f6902ee63d30e53974f):
- Example 1:
  - [SingleWalletSummaryQuery Subscription Query (line 167)](https://github.com/nklmish/axon-casino/blob/019d14c1cd25972fb4a48f6902ee63d30e53974f/src/main/kotlin/com/nklmish/demo/playerui/PlayerUI.kt#L167):
    ```kotlin
    val queryResult = queryGateway.subscriptionQuery(
        SingleWalletSummaryQuery(cmd.walletId),                     // 1
        ResponseTypes.instanceOf(WalletSummary::class.java),        // 2
        ResponseTypes.instanceOf(WalletSummaryUpdate::class.java))  // 3
    ```
    - 1: Subscribe to `SingleWalletSummaryQuery`.
    - 2: Initial subscription will return the response type: `ResponseTypes.instanceOf(WalletSummary::class.java)`
    - 3: Subsequent updates in the subscription will be of the response type: `ResponseTypes.instanceOf(WalletSummaryUpdate::class.java)`
  - [SingleWalletSummaryQuery `@QueryHandler`](https://github.com/nklmish/axon-casino/blob/019d14c1cd25972fb4a48f6902ee63d30e53974f/src/main/kotlin/com/nklmish/demo/walletsummary/WalletSummaryProjection.kt#L105):
    - Provides the initial result to the `SingleWalletSummaryQuery` subscription query.
    - This initial result is of type: `WalletSummary`.
  - [SingleWalletSummaryQuery queryUpdateEmitter.emit(..)](https://github.com/nklmish/axon-casino/blob/019d14c1cd25972fb4a48f6902ee63d30e53974f/src/main/kotlin/com/nklmish/demo/walletsummary/WalletSummaryProjection.kt):
    - Provides the subsequent updates to the `SingleWalletSummaryQuery` subscription query.
    - These are updates are of the type `WalletSummaryUpdate`.
    - There are multiple `@EventHandlers` which do this.
      - Search for `queryUpdateEmitter.emit(` on the page to see them e.g. line 41, 49, 58, etc.
- Example 2:
  - [TotalDepositedQuery Subscription Query (line 20)](https://github.com/nklmish/axon-casino/blob/019d14c1cd25972fb4a48f6902ee63d30e53974f/src/main/kotlin/com/nklmish/demo/managementdata/RestEndpoints.kt#L20):
    ```kotlin
    return queryGateway.subscriptionQuery(TotalDepositedQuery(),                   // 1
           ResponseTypes.multipleInstancesOf(TotalDepositedSample::class.java),    // 2
           ResponseTypes.instanceOf(TotalDepositedSample::class.java)).updates()   // 3
    ```
    - 1: Subscribe to `TotalDepositedQuery`.
    - 2: Initial subscription will return the response type: `ResponseTypes.multipleInstancesOf(TotalDepositedSample::class.java)`
    - 3: Subsequent updates in the subscription will be of the response type: `ResponseTypes.instanceOf(TotalDepositedSample::class.java)`
  - [TotalDepositedQuery `@QueryHandler`](https://github.com/nklmish/axon-casino/blob/019d14c1cd25972fb4a48f6902ee63d30e53974f/src/main/kotlin/com/nklmish/demo/managementdata/TotalDepositedProjection.kt#L97):
    - Provides the initial result to the `TotalDepositedQuery` subscription query.
    - This initial result is of type: `List<TotalDepositedSample>`.
  - [TotalDepositedQuery queryUpdateEmitter.emit(..)](https://github.com/nklmish/axon-casino/blob/019d14c1cd25972fb4a48f6902ee63d30e53974f/src/main/kotlin/com/nklmish/demo/managementdata/TotalDepositedProjection.kt#L79):
    - Provides the subsequent updates to the `TotalDepositedSample` subscription query.
    - These are updates are of the type `TotalDepositedSample`.

(Java) [fransvanbuul/sq-webinar](https://github.com/fransvanbuul/sq-webinar/tree/e99d378ebfd1b1fd79c08dbe0b558960a3fba12b):
- [`FetchCardSummariesQuery` Subscription Query](https://github.com/fransvanbuul/sq-webinar/blob/e99d378ebfd1b1fd79c08dbe0b558960a3fba12b/src/main/java/io/axoniq/demo/sqwebinar/restfrontend/GcRestController.java#L30):
  ```java
   return queryGateway.subscriptionQuery(
          new FetchCardSummariesQuery(0,1, new CardSummaryFilter("")), // 1
          ResponseTypes.multipleInstancesOf(CardSummary.class),        // 2
          ResponseTypes.instanceOf(CardSummary.class)).updates();      // 3
   ```
  - 1: Subscribe to `FetchCardSummariesQuery`.
  - 2: Initial subscription will return the response type: `ResponseTypes.multipleInstancesOf(CardSummary.class)`
  - 3: Subsequent updates in the subscription will be of the response type: `ResponseTypes.instanceOf(CardSummary.class)`
- [FetchCardSummariesQuery `@QueryHandler`](https://github.com/fransvanbuul/sq-webinar/blob/e99d378ebfd1b1fd79c08dbe0b558960a3fba12b/src/main/java/io/axoniq/demo/sqwebinar/readside/CardSummaryProjection.java#L49):
  - Provides the initial result to the `FetchCardSummariesQuery` subscription query.
  - The initial result is of type: `List<CardSummary>`
- [FetchCardSummariesQuery queryUpdateEmitter.emit(..)](https://github.com/fransvanbuul/sq-webinar/blob/e99d378ebfd1b1fd79c08dbe0b558960a3fba12b/src/main/java/io/axoniq/demo/sqwebinar/readside/CardSummaryProjection.java#L37):
  - Provides the subsequent updates to the `FetchCardSummariesQuery` subscription query.
  - These are updates are of the type `CardSummary`.

(Kotlin) [idugalic/digital-restaurant](https://github.com/idugalic/digital-restaurant/tree/920248e62c5b7d9b8d3c365b2f911355aa19c7db):
- Lots of examples in this repo.
