# Axon Framework Resource Reference Doc
This document is a collation of resources for understanding the Axon Framework:
- Feel free to:
    - use if to lookup something (code snippets/examples/tips).
    - contribute a change if something is wrong or missing.

<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Contents**

  - [Project Structure (Start Here)](#project-structure-start-here)
- [Examples of testing](#examples-of-testing)
- [`@Aggregate` Tips](#aggregate-tips)
  - [Creating an `@Aggregate` from another `@Aggregate`](#creating-an-aggregate-from-another-aggregate)
    - [Using `AggregateLifecycle.createNew(Class<T>, Callable<T>)` (preferred method)](#using-aggregatelifecyclecreatenewclasst-callablet-preferred-method)
    - [From an `@EventHandler` (Outdated way but still useful to know)](#from-an-eventhandler-outdated-way-but-still-useful-to-know)
- [`@Repository<T>` Tips](#repositoryt-tips)
  - [Autowiring a `@Repository<T>`](#autowiring-a-repositoryt)
  - [Manually creating a `@Repository<T>` bean](#manually-creating-a-repositoryt-bean)
    - [Backed by an `EventStore` repository](#backed-by-an-eventstore-repository)
- [Examples of snapshotting](#examples-of-snapshotting)
  - [idugalic/digital-restaurant](#idugalicdigital-restaurant)
- [Tracking Event Processor](#tracking-event-processor)
  - [Resetting a tracking event processor](#resetting-a-tracking-event-processor)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

## Project Structure (Start Here)

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
   
# Examples of testing

- Unit Testing an `@Aggregate`: 
  - [ChatRoomTest.java](https://github.com/AxonIQ/axon-quick-start/blob/master/chat-scaling-out/src/test/java/io/axoniq/labs/chat/commandmodel/ChatRoomTest.java)
  - 

# `@Aggregate` Tips

## Creating an `@Aggregate` from another `@Aggregate`

### Using `AggregateLifecycle.createNew(Class<T>, Callable<T>)` (preferred method)



### From an `@EventHandler` (Outdated way but still useful to know) 

>    *This section remains for posterity to describe how you used to create an 
>     aggregate from another aggregate in the Axon Framework (I think this was pre 4.0).*

You can build an event listener to listen for an event which then triggers the creation of an aggregate.

In the [Axon Trader](https://github.com/AxonFramework/Axon-trader/tree/1e987bb111768451d70790e1378ae40dcf93c17b) app
the relationship between a "company" and an "order book" means that one cannot exist
without another:
- After a `CompanyCreatedEvent` we need to make sure that a `CreateOrderBookCommand` is 
  issued to ensure the creation of the corresponding order book and the business invariant is maintained.
- We do this by creating an "event listener" `@Component` (some people may call it a `@Service`).

Suppose, the following [command](https://github.com/AxonFramework/Axon-trader/blob/1e987bb111768451d70790e1378ae40dcf93c17b/companies/src/main/java/org/axonframework/samples/trader/company/command/CompanyOrderBookListener.java) and [event](https://github.com/AxonFramework/Axon-trader/blob/1e987bb111768451d70790e1378ae40dcf93c17b/core-api/src/main/java/org/axonframework/samples/trader/api/company/events.kt) APIs for the [Company](https://github.com/AxonFramework/Axon-trader/blob/1e987bb111768451d70790e1378ae40dcf93c17b/companies/src/main/java/org/axonframework/samples/trader/company/command/Company.java) `@Aggregate`:

```kotlin
data class CreateCompanyCommand(override val companyId: CompanyId, /* ... rest of the fields snipped */)
data class AddOrderBookToCompanyCommand(override val companyId: CompanyId,  /* ... rest of the fields snipped */)
```
```kotlin
data class CompanyCreatedEvent(override val companyId: CompanyId, /* ... rest of the fields snipped */)
data class OrderBookAddedToCompanyEvent(override val companyId: CompanyId, /* ... rest of the fields snipped */)
```

And the following (snipped) [command](https://github.com/AxonFramework/Axon-trader/blob/1e987bb111768451d70790e1378ae40dcf93c17b/core-api/src/main/java/org/axonframework/samples/trader/api/orders/trades/commands.kt) and [event](https://github.com/AxonFramework/Axon-trader/blob/1e987bb111768451d70790e1378ae40dcf93c17b/core-api/src/main/java/org/axonframework/samples/trader/api/orders/trades/events.kt) APIs for the [OrderBook](https://github.com/AxonFramework/Axon-trader/blob/1e987bb111768451d70790e1378ae40dcf93c17b/trade-engine/src/main/java/org/axonframework/samples/trader/tradeengine/command/OrderBook.java) `@Aggregate`:
```kotlin
data class CreateOrderBookCommand(override val orderBookId: OrderBookId)
```

```kotlin
data class OrderBookCreatedEvent(override val orderBookId: OrderBookId)
```

then you can build an event listener like so:

```java
/**
 * This listener is used to create order book instances when we have created a new company</p>
 * TODO #28 the OrderBook aggregate should be instantiated from the Company aggregate, as is possible since axon 3.3
 **/
@Service
@ProcessingGroup("commandPublishingEventHandlers")
public class CompanyOrderBookListener {

    private static final Logger logger = LoggerFactory.getLogger(CompanyOrderBookListener.class);

    private final CommandGateway commandGateway;

    @Autowired
    public CompanyOrderBookListener(CommandGateway commandGateway) {
        this.commandGateway = commandGateway;
    }

    @EventHandler
    public void on(CompanyCreatedEvent event) {
        logger.debug("About to dispatch a new command to create an OrderBook for the company {}", event.getCompanyId());

        OrderBookId orderBookId = new OrderBookId();
        commandGateway.send(new CreateOrderBookCommand(orderBookId));
        commandGateway.send(new AddOrderBookToCompanyCommand(event.getCompanyId(), orderBookId));
    }
}
```
and the [OrderBook aggregate](https://github.com/AxonFramework/Axon-trader/blob/1e987bb111768451d70790e1378ae40dcf93c17b/trade-engine/src/main/java/org/axonframework/samples/trader/tradeengine/command/OrderBook.java) has a command handler annotation on a constructor like this:

```java

@Aggregate
public class OrderBook {

    @AggregateIdentifier
    private OrderBookId orderBookId;

    @CommandHandler
    public OrderBook(CreateOrderBookCommand cmd) {
        apply(new OrderBookCreatedEvent(cmd.getOrderBookId()));
    }

    // ... rest of class contents snipped...
}
```

This snippet:
- Shows a slightly outdated way of creating an `@Aggregate`, in that:
  - you need to create a separate event listener component and react to it.
- The preferred way of creating an aggregate from another aggregate now is to just use the `AggregateLifecycle.createNew(...)` method. See that subsection for examples.






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

## Resetting a tracking event processor

See:
- https://github.com/idugalic/digital-restaurant/blob/b9fa7ad168be418456b1815172d45bd508388479/drestaurant-apps/drestaurant-monolith-rest/src/main/kotlin/com/drestaurant/admin/AxonAdministration.kt



