const abi = [
    {
        "anonymous" : false,
        "inputs": [
            {
              "internalType": "string",
              "name": "greeting",
              "type": "string"
            }
          ],
          "stateMutability": "nonpayable",
          "type": "constructor"
        },
        {
          "anonymous": false,
          "inputs": [
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "id",
              "type": "uint256"
            },
            {
              "indexed": false,
              "internalType": "address",
              "name": "bidder",
              "type": "address"
            },
            {
              "indexed": false,
              "internalType": "uint256",
              "name": "price",
              "type": "uint256"
            }
          ],
          "name": "bidded",
          "type": "event"
        },
        {
          "inputs": [],
          "name": "executor",
          "outputs": [
            {
              "internalType": "address payable",
              "name": "",
              "type": "address"
            }
          ],
          "stateMutability": "view",
          "type": "function",
          "constant": true
        },
        {
          "inputs": [],
          "name": "stage",
          "outputs": [
            {
              "internalType": "enum Deal.Stage",
              "name": "",
              "type": "uint8"
            }
          ],
          "stateMutability": "view",
          "type": "function",
          "constant": true
        },
        {
          "inputs": [],
          "name": "start",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "increaseFunds",
          "outputs": [],
          "stateMutability": "payable",
          "type": "function",
          "payable": true
        },
        {
          "inputs": [
            {
              "internalType": "uint8",
              "name": "number",
              "type": "uint8"
            },
            {
              "internalType": "uint256",
              "name": "amount",
              "type": "uint256"
            }
          ],
          "name": "bet",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "spin",
          "outputs": [
            {
              "internalType": "uint256",
              "name": "",
              "type": "uint256"
            }
          ],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "widthdraw",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        },
        {
          "inputs": [],
          "name": "getFunds",
          "outputs": [
            {
              "internalType": "uint256",
              "name": "",
              "type": "uint256"
            }
          ],
          "stateMutability": "view",
          "type": "function",
          "constant": true
        },
        {
          "inputs": [],
          "name": "bankFunds",
          "outputs": [
            {
              "internalType": "uint256",
              "name": "",
              "type": "uint256"
            }
          ],
          "stateMutability": "view",
          "type": "function",
          "constant": true
        },
        {
          "inputs": [],
          "name": "playersSize",
          "outputs": [
            {
              "internalType": "uint256",
              "name": "",
              "type": "uint256"
            }
          ],
          "stateMutability": "view",
          "type": "function",
          "constant": true
        },
        {
          "inputs": [],
          "name": "changeStateBet",
          "outputs": [],
          "stateMutability": "nonpayable",
          "type": "function"
        }
      ]

  // Call a function of the contract
var contract
var fromAddress;
var toAddress;


async function test()
{
    console.log(fromAddress);
    response = await contract.methods.changeGreeting("bh hb").send(
        {
            from: fromAddress,
            gas: "21000"
          }
    );
    console.log(response);
}


async function greet() {
    string = await contract.methods.greet().call();
    alert(string);
}

async function connect()
{
    if (typeof window.ethereum === "undefined") {
        alert("ERROR: Metamask is not installed, please install it firstly in browser")
        return;
    }

    await window.ethereum.request({method: "eth_requestAccounts"});
    var w3 = new Web3(window.ethereum);
    contract = new w3.eth.Contract(abi, "0x055CE6FE23a90ad8C866Ca0E6270cAcB9aac4546");

    w3.eth.getAccounts((error, accounts) => {
        if (error) {
          // Handle error
        } else {
          // The user's Ethereum addresses are stored in the accounts array
          // You can use the first address in the array as the from parameter
          // when calling a contract function
            setupAddresses(accounts);
        }
    });
}


let images = ["dice-01.svg",
"dice-02.svg",
"dice-03.svg",
"dice-04.svg",
"dice-05.svg",
"dice-06.svg"];
let dice = document.querySelectorAll("img");
let btn = document.getElementById("button");

function roll(){
    dice.forEach(function(die){
        die.classList.add("shake");
		btn.disabled = true;
    });
    setTimeout(function(){
		btn.disabled = false;
        dice.forEach(function(die){
            die.classList.remove("shake");
        });
        let dieOneValue = Math.floor(Math.random()*6);
        let dieTwoValue = Math.floor(Math.random()*6);
        console.log(dieOneValue,dieTwoValue);
        document.querySelector("#die-1").setAttribute("src", images[dieOneValue]);
        document.querySelector("#die-2").setAttribute("src", images[dieTwoValue]);
        document.querySelector("#total").innerHTML = "The rolled combination is " + ( (dieOneValue +1) + (dieTwoValue + 1) );
    },
    1000
    );
}

//roll();