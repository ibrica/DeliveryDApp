pragma solidity ^0.4.18;

import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/Deliveries.sol";

//TODO: Write tests
contract TestDeliveries {

  function testSomething() {
    Deliveries deliveries = new Deliveries();
    

    uint expected = 0;

    Assert.equal(deliveries.getSetPackages().length, expected, "Dummy test");
  }

}
