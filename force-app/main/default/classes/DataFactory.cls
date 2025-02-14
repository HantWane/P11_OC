/**
 * Utility class for creating test data in Salesforce.
 * Provides methods to create and insert various types of records, such as Accounts, Products, Pricebook Entries, Orders, and Order Items.
 */
@isTest
public with sharing class DataFactory {

    /**
     * Creates and inserts an Account record with the given name.
     *
     * @param accountName The name of the Account to be created.
     * @return The created and inserted Account record.
     */
    public static Account createAccount(String accountName) {
        Account acc = new Account(Name = accountName);
        insert acc;
        return acc;
    }

    /**
     * Creates and inserts a Product2 record with the given name and sets it as active.
     *
     * @param productName The name of the Product to be created.
     * @return The created and inserted Product2 record.
     */
    public static Product2 createProduct(String productName) {
        Product2 prod = new Product2(Name = productName, IsActive = true);
        insert prod;
        return prod;
    }

    /**
     * Creates and inserts a PricebookEntry record for the given Product2 ID and unit price.
     *
     * @param product2Id The ID of the Product2 record to associate with the PricebookEntry.
     * @param unitPrice The unit price of the PricebookEntry.
     * @return The created and inserted PricebookEntry record.
     */
    public static PricebookEntry createPriceBookEntry(Id product2Id, Double unitPrice) {
        PricebookEntry pricebookEntry = new PricebookEntry(
            Pricebook2Id = Test.getStandardPricebookId(),
            Product2Id = product2Id,
            UnitPrice = unitPrice,
            IsActive = true
        );
        insert pricebookEntry;
        return pricebookEntry;
    }

    /**
     * Creates and inserts Order records with the specified details.
     *
     * @param accountId The ID of the Account to associate with the Orders.
     * @param status The status of the Orders.
     * @param effectiveDate The effective date of the Orders.
     * @param shipmentCost The shipment cost of the Orders.
     * @param numberOfOrders The number of Order records to create.
     * @return A list of created and inserted Order records.
     */
    public static List<Order> createOrders(Id accountId, String status, Date effectiveDate, Decimal shipmentCost, Integer numberOfOrders) {
        List<Order> ordersList = new List<Order>();
        for (Integer i = 0; i < numberOfOrders; i++) {
            Order order = new Order(
                AccountId = accountId,
                Status = status,
                EffectiveDate = effectiveDate,
                Pricebook2Id = Test.getStandardPricebookId()
            );
            ordersList.add(order);
        }
        insert ordersList;
        return ordersList;
    }

    /**
     * Overloaded method to create a single Order record.
     *
     * @param accountId The ID of the Account to associate with the Order.
     * @param status The status of the Order.
     * @param effectiveDate The effective date of the Order.
     * @param shipmentCost The shipment cost of the Order.
     * @return The created and inserted Order record.
     */
    public static Order createOrder(Id accountId, String status, Date effectiveDate, Decimal shipmentCost) {
        List<Order> ordersList = createOrders(accountId, status, effectiveDate, shipmentCost, 1);
        return ordersList[0];
    }

    /**
     * Creates and inserts OrderItem records for the given orders and associated product/pricebook data.
     *
     * @param ordersList A list of Order records to associate with the OrderItems.
     * @param orderData A map containing the Product2Id and PricebookEntryId for the OrderItems.
     * @param unitPrice The unit price of the OrderItems.
     * @return A list of created and inserted OrderItem records.
     */
    public static List<OrderItem> createOrderItems(List<Order> ordersList, Map<String, Id> orderData, Decimal unitPrice) {
        List<OrderItem> orderItems = new List<OrderItem>();
        for (Order order : ordersList) {
            OrderItem orderItem = new OrderItem(
                OrderId = order.Id,
                Product2Id = orderData.get('Product2Id'),
                PricebookEntryId = orderData.get('PricebookEntryId'),
                Quantity = 1,
                UnitPrice = unitPrice
            );
            orderItems.add(orderItem);
        }
        insert orderItems;
        return orderItems;
    }
}