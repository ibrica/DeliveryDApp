pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Deliveries.sol";

//Test cases for contract
contract TestDeliveries {

  function testDeliveryPrice() {
    Deliveries deliveries = new Deliveries();
    

    uint expected = 80000000000000;

    Assert.equal(deliveries.deliveryPrice(), expected, "Should return default price");
  }


  function testCreatePackage() {

    address addr = DeployedAddresses.Deliveries();
    Deliveries deliveries = Deliveries(addr);
    
    Assert.equal(deliveries.createPackage(addr,"Pickup address", "Delivery address",80000000000000), 0, "Should send a package and return id");

    Assert.equal(deliveries.getSentPackages(addr).length, 1, "Should have a one sent package");

    Assert.equal(deliveries.getReceivedPackages(addr).length, 1, "Should have a one received package");
  }

}
