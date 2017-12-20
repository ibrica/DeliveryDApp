// Import the CSS for Webpack
import "../stylesheets/app.css";

// Import libraries we need.
import { default as Web3} from 'web3';
import { default as contract } from 'truffle-contract' //Using truffle instead of pure web3 to get promises

// Import contract artifacts
import deliveries_artifacts from '../../build/contracts/Deliveries.json'

//Create truffle contract abstraction
let Deliveries = contract(deliveries_artifacts);

var accounts, account;
var deliveries, sentPackages, receivedPackages;

window.App = {
  start: function() {
    let self = this;

    // Prepare the contract abstraction
    Deliveries.setProvider(web3.currentProvider);

    // Get the initial account balance so it can be displayed.
    web3.eth.getAccounts(function(err, accs) {
      if (err != null) {
        alert("There was an error fetching your accounts.");
        return;
      }

      if (accs.length == 0) {
        alert("Couldn't get any accounts! Make sure your Ethereum client is configured correctly.");
        return;
      }

      accounts = accs;
      account = accounts[0];

      self.getPackages();
    });
  },

  setStatus: function(message) {
    var status = document.getElementById("status");
    status.innerHTML = message;
  },

  getPackages: function() {
    let self = this;

    Deliveries.deployed().then(function(instance) {
      deliveries = instance;
      return deliveries.getSentPackages.call(account);
    }).then(function(value) {
      sentPackages = value?value.valueOf():{};
      return deliveries.getReceivedPackages.call(account); //explicit call to avoid transaction
    }).then(function(value) {
      receivedPackages = value?value.valueOf():{};
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error getting package info; see log.");
    });
    console.log("Sent:" + sentPackages + "\nReceived:" + receivedPackages);
  },

  //Create a new package delivery
  sendPackage: function() {
    let self = this;

    let evalue = parseInt(document.getElementById("evalue").value); //estimated value
    let receiver = document.getElementById("receiver").value;
    let pickupAddress = document.getElementById("pickupAddress").value;
    let deliveryAddress = document.getElementById("deliveryAddress").value;

    this.setStatus("Initiating transaction... (please wait)");

    Deliveries.deployed()
    .then(function(instance) {
      deliveries = instance;
      return deliveries.createPackage(receiver, pickupAddress, deliveryAddress, evalue , {from:account});
    }).then(function(Id) {
      console.log(Id);
      self.setStatus("Transaction complete!");
      self.getPackages();
    }).catch(function(e) {
      console.log(e);
      self.setStatus("Error sending package ; see log.");
    });
  }

  /* WEB3.ETH test
  ,test: function(message) {
    web3.eth.defaultAccount = web3.eth.accounts[0];
    console.log(deliveries_artifacts.abi)
    let deliveriesContract = web3.eth.contract(deliveries_artifacts.abi);
    deliveries = deliveriesContract.at("0xb37eddaeeb7b626717d74c53330dfb67eb2fcfc5");
    let value = deliveries.getReceivedPackages.call(account, (value)=>{
      console.log(value);
    });
  }
  */
};

//Setup client
window.addEventListener('load', function() {
  // Checking if Web3 has been injected by the browser (Mist/MetaMask)
  if (typeof web3 !== 'undefined') {
    console.warn("Using web3 detected from external source. ")
    // Use Mist/MetaMask's provider
    window.web3 = new Web3(web3.currentProvider);
  } else {
    console.warn("No web3 detected. Falling back to local");
    window.web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
  }
  

  App.start();
});
