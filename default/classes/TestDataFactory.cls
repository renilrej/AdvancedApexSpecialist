/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup()
    {
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup colGroup = new CollaborationGroup();
        colGroup.Name = 'Test'+ Constants.INVENTORY_ANNOUNCEMENTS;
        colGroup.CanHaveGuests  = false;
        colGroup.CollaborationType = 'public';
        colGroup.IsArchived = false;
        colGroup.IsAutoArchiveDisabled = false;
        return colGroup;
    }

    //@name CreateProducts
    //@description Constructs a list of Product2 records for unit tests
    public static List<Product2> ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.
        
        List<Schema.PickListEntry> familyValueList = Product2.Family.getDescribe().getPickListValues();
        Integer listSize = familyValueList.size();
        
        List<Product2> productList = new List<Product2>();
        for (Integer i = 0; i < cnt; i++) {
            Product2 p = new Product2();
            p.Name = 'Product ' + i;
            p.Family = familyValueList[Math.mod(i, listSize)].getValue();
            p.Initial_Inventory__c = 10;
            p.IsActive = true;
            productList.add(p);
        }
        return productList;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PricebookEntry> ConstructPricebookEntries(List<Product2> prods)
    {
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook
        List<PricebookEntry> priceBookEntires = new List<PricebookEntry>();
        
        for(Product2 prod : prods)
        {
            PricebookEntry pbe = new PricebookEntry();
            pbe.IsActive = true;
            pbe.Product2Id = prod.Id;
            pbe.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            pbe.UnitPrice = 1;

            priceBookEntires.add(pbe);
        }
        return priceBookEntires;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt)
    {
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.

        List<Account> accList = new List<Account>();

        for(Integer i = 0 ; i < cnt; i++)
        {
            Account acc = new Account();
            acc.Name = 'Account'+i;
            accList.add(acc);
        }
        return accList;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts)
    {
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> conList = new List<Contact>();
        Integer accListSize = accts.size();

        for(Integer i = 0; i < cnt; i++)
        {
            Contact con = new Contact();
            con.LastName = 'Contact'+i;
            con.AccountId = accts[Math.mod(i, accListSize)].Id;
            conList.add(con);
        }
        return conList;
    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts)
    {
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Order> orders = new List<Order>();
        Integer acctsListSize = accts.size();
        
        for(Integer i = 0; i < cnt; i++)
        {
            Order ord = new Order();
            ord.Name = 'Order'+i;
            ord.AccountId = accts[Math.mod(i, acctsListSize)].Id;
            ord.EffectiveDate = Date.today(); 
            ord.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            ord.Status = Constants.DRAFT_ORDER_STATUS;
            orders.add(ord);
        }
        return orders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords)
    {
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> ordrItemList = new List<OrderItem>();

        Integer pbesListSize = pbes.size();
        Integer ordsListSize = ords.size();

        for(Integer i = 0; i < cnt; i++)
        {
            OrderItem ordrItem = new OrderItem();
            ordrItem.UnitPrice = 1;
            ordrItem.Quantity = Constants.DEFAULT_ROWS;
            ordrItem.PriceBookEntryId  = pbes[Math.mod(i, pbesListSize)].Id;
            ordrItem.OrderId = ords[Math.mod(i, ordsListSize)].Id;

            ordrItemList.add(ordrItem);
        }
        return ordrItemList;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt)
    {
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.
        insert ConstructCollaborationGroup();

        List<Product2> prodList = ConstructProducts(cnt);
        insert prodList;

        List<PricebookEntry> priceBooks = ConstructPricebookEntries(prodList);
        insert priceBooks;

        List<Account> accList = ConstructAccounts(cnt);
        insert accList;
        insert ConstructContacts(cnt, accList);

        List<Order> orders = ConstructOrders(cnt, accList);
        insert orders;

        insert ConstructOrderItems(cnt, priceBooks, orders);
    }

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered)
    {
        Integer sumQuantity = Integer.valueOf(originalProduct.Quantity_Ordered__c) + qtyOrdered;
        System.assertEquals(updatedProduct.Quantity_Ordered__c, sumQuantity);
    }

}