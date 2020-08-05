pragma solidity ^0.4.11;

contract Purchase {
    uint public value;
    address public seller;
    address public buyer;
    enum State {Created, Locked, Inactive}
    State public state;
    uint trackingNo = 0;

    struct Shipment {
        uint trackingNumber;
        address from;
        address to;
        uint quantity;
    }

    function Purchase () payable {
        buyer = msg.sender;
    }

    modifier condition(bool _condition) {
        require(_condition);
        _;
    }

    modifier onlyBuyer() {
        require(msg.sender == buyer);
        _;
    }

    modifier onlySeller() {
        require(msg.sender == seller);
        _;
    }

    modifier inState(State _state) {
        require(state == _state);
        _;
    }

    mapping (uint => Shipment) shipmentList;    
    event Aborted();
    event PurchaseConfirmed(address from, address to, uint _quantity);
    event ItemShipped(uint trackingNumber, address to, uint _quantity);
    event ItemReceived(uint trackingNumber, uint _quantity);

    //The buyer places an order and sends ether to the contract to be 
    //placed in escrow until the transaction is completed 
    function placeOrder ()
        inState(State.Created)
        payable
    {
        value = msg.value;
    }

    //The buyer has the option to abort the contract before it is signed
    //by the seller
    function abort  ()
        onlyBuyer
        inState(State.Created)
    {
        Aborted();
        state = State.Inactive;
        buyer.transfer(this.balance);
    }

    /// Confirm the purchase order as seller.
    function confirmPurchase()
        inState(State.Created)
    {
        seller = msg.sender;
        PurchaseConfirmed(seller, buyer, value);
        state = State.Locked;
    }



    function shipProduct() public 
        onlySeller
        inState(State.Locked)
    {
        // increase the tracking number
        trackingNo++;
        
        // store the shipment information
        shipmentList[trackingNo] = Shipment(trackingNo, seller, buyer, value);
        ItemShipped(trackingNo, buyer, value);
    }


    /// Confirm that the buyer received the item.
    /// This will release the locked ether to the seller
    function confirmReceived()
        onlyBuyer
        inState(State.Locked)
    {
        ItemReceived(trackingNo, value);
        state = State.Inactive;
        seller.transfer(value);
    }
    
    //Buyer can place a new order with a different seller using same contract
    function newOrder ()
        onlyBuyer
        inState(State.Inactive)
    {
     state = State.Created;
    }
} 