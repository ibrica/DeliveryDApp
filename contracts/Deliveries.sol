pragma solidity ^0.4.18;
pragma experimental ABIEncoderV2; //Needed to return array of structs


// Example of package delivery smart contract
contract Deliveries {
	 
	address owner; //Delivery firm

	// Defines a new package type with delivery info.
    struct Package {
        address sender; //Package sender
		address receiver; //Package receiver
		string pickupStreetAddress;
		string deliverStreetAddress;
        uint256 value; //Estimated value in wei
		DeliveryStatus status; //Current status 
		uint sentTimestamp;
		uint deliveredTimestamp;
		uint cancelledTimestamp; //time of cancellation
    }

	//Current status of delivery
	enum DeliveryStatus {InProgress, Delivered, Cancelled}

	//Price of package delivery, public so solc creates getter for web3
	uint256 public deliveryPrice;

	// All of the packages, dynamic array
	Package[] allPackages;
	
	//Sent and recieved packages per user
	//Package's info is accesed through function
	mapping (address => uint[]) sentPackages; 
	mapping (address => uint[]) receivedPackages; //Doesn't mean that delivery is successfull

	// Events
    event PackageCreated(	uint id, 
							address sender, 
							address receiver, 
							string pickupStreetAddress, 
							string deliverStreetAddress, 
							uint256 value);
    event DeliveryCompleted(uint id);
	event DeliveryCancelled(uint id);


	modifier onlyOwner() {
        require(msg.sender == owner);
        _;
	}


	modifier onlySenderReceiverOrOwner(uint id) {
        require (msg.sender == owner || msg.sender == allPackages[id].sender || msg.sender == allPackages[id].receiver);
        _;
	}

	function Deliveries() {
		owner = msg.sender;
		deliveryPrice = 80000000000000; //Default price for all deliveries
	}

	/**
	 * New package for delivery created 
	 */
	function createPackage( 
		address receiver,
		string pickupStreetAddress,
		string deliverStreetAddress,
        uint256 value
	) payable returns (uint packageId)
	{
		packageId = allPackages.length++;
		Package storage p = allPackages[packageId];
		p.sender = msg.sender;
		p.receiver = receiver;
		p.pickupStreetAddress = pickupStreetAddress;
		p.deliverStreetAddress = deliverStreetAddress;
		p.value = value;
		p.status = DeliveryStatus.InProgress;
		p.sentTimestamp = now;
		//Add to sent packages
		sentPackages[p.sender].push(packageId);
		//Add to sent to (recieved) packages
		receivedPackages[p.receiver].push(packageId);
		//Fire event
		PackageCreated(packageId, p.sender, p.receiver, p.pickupStreetAddress, p.deliverStreetAddress, value);

		return packageId;

	}
	
	/**
	 * Delivery completed, only possible from delivery company 
	 */
	function completeDelivery(uint packageId, uint deliveredTimestamp) onlyOwner() returns(bool) {
		require(allPackages[packageId].status == DeliveryStatus.InProgress);
	    allPackages[packageId].status = DeliveryStatus.Delivered;
	    allPackages[packageId].deliveredTimestamp = deliveredTimestamp;
	    DeliveryCompleted(packageId);
		owner.transfer(deliveryPrice); //Collect delivery 
		return true;
	}
	
	/**
	 * Cancelling of delivery, possible from sender, receiver or delivery company 
	 * Send money back to sender
	 */
	function cancelDelivery(uint packageId) onlySenderReceiverOrOwner(packageId) returns (bool) {
		require(allPackages[packageId].status == DeliveryStatus.InProgress);
		assert(this.balance >= deliveryPrice); //Should be enough money for refund
		if (!allPackages[packageId].sender.send(deliveryPrice)) { 
                return false; //Money back failed, retry
		}
	    allPackages[packageId].status = DeliveryStatus.Cancelled;
	    allPackages[packageId].cancelledTimestamp = now;
	    DeliveryCancelled(packageId);
		return true;
	}

	/**
	 * Set delivery price in wei, same for all deliveries
	 */
	function setDeliveryPrice(uint256 price) onlyOwner { 
		deliveryPrice = price;
	}

	/** 
	* Return all packages sent from given address
 	*/
	function getSentPackages(address addr) constant returns (uint[]) {  //return array of structs  still not working
		return sentPackages[addr];
	}

	/** 
	* Return all packages recieved on given address
 	*/
	function getReceivedPackages(address addr) constant returns (uint[]) { // returns (Package[])Experimental feature returning array of structs still not working

		return receivedPackages[addr];
	}



}
