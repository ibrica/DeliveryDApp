var Deliveries = artifacts.require("./Deliveries.sol");

//TODO: Write tests
contract('Deliveries', function(accounts) {
    it("Should return default price", function() {
        return Deliveries.deployed().then(function(instance) {
          return instance.deliveryPrice.call();
        }).then(function(price) {
          assert.equal(price.valueOf(), 80000000000000, "wrong delivery price");
        });
      });
      let deliveries;
      it("Should send a package and return id, have one sent and recieved package for address", function() {   
        return Deliveries.deployed().then(function(instance) {
            deliveries = instance;
            //Send one package to myself
            return deliveries.createPackage(accounts[0],"Pickup address", "Delivery address",80000000000000);
        }).then(function(packageId) {
            assert.equal(packageId, 0, "Create package didn't return expected id");
            return deliveries.getSentPackages.call(accounts[0]);
        }).then(function(sentPackages) {
            assert.equal(sentPackages.length, 1, "Didn't find one sent package for address");
            return deliveries.getReceivedPackages.call(accounts[0]);
        }).then(function(receivedPackages) {
            assert.equal(receivedPackages.length, 1, "Didn't find one received package for address");            
        });
    });

});
