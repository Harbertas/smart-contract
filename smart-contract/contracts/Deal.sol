// SPDX-License-Identifier: MIT

pragma solidity >=0.4.22 <0.9.0;

contract Deal {

    //STAGES
    enum Stage {Init, SetUp, Bet, Play}

    Stage public stage = Stage.Init;

    //EVENTS
    event bidded(uint id, address bidder, uint price);

    //Storage variables
    mapping(address => uint256) registeredFunds;
    mapping(address => uint8) chosenNumber;
    mapping(address => bool) approvedPlayer;
    mapping(address => uint256) bets;
    address[] players;
    uint256 c;
    uint8[] endings = [2, 3, 4, 5, 6, 7, 8 , 9, 10, 11, 12];

    //MODIFIERS
    modifier validStage(Stage reqStage)
    { 
        require(stage == reqStage);
        _;
    }

    modifier isExecutor()
    { 
        require(msg.sender == executor, "Only The Executor Can Change the Bet");
        _;
    }

    uint startTime;
    address payable public executor;

    constructor(string memory greeting) {
        executor = payable(msg.sender);
        stage = Stage.SetUp;
        startTime = block.timestamp;
    }

    function start() public validStage(Stage.SetUp){
        if (approvedPlayer[msg.sender] != true) {
            approvedPlayer[msg.sender] = true;
            players.push(msg.sender);
        }
        if(players.length > 1) {
            //stage = Stage.Bet;
        }
    }

    function increaseFunds() public payable {
        require(msg.value > 0, "Must send ETH");
        registeredFunds[msg.sender] += msg.value;
    }

    function bet(uint8 number, uint256 amount) public validStage(Stage.Bet){
        require(approvedPlayer[msg.sender], "You Are Not Approved");
        require(registeredFunds[msg.sender] >= amount, "Not enough Funds");
        require(number > 1 && number < 13, "Choose Between [2-12]");
        require(bets[msg.sender] == 0, "You Have Already Betted");
        bets[msg.sender] = amount;
        chosenNumber[msg.sender] = number;
        registeredFunds[msg.sender] -= amount;
        c++;
        if(c == players.length) stage = Stage.Play;
    }

    function spin() public validStage(Stage.Play) returns(uint256){
        require(msg.sender == executor, "Only Executor Can Start The Game");
        address[] memory newArray;
        uint256 number = 5;
        for(uint256 i = 0; i < players.length; i++) {
            address playerAddress = players[i];
            if(bets[playerAddress] > 0) {
                 if(chosenNumber[playerAddress] == number) {
                    bets[playerAddress]*=2;
                    registeredFunds[playerAddress] += bets[playerAddress];
                 }
                chosenNumber[playerAddress] = 0;
                bets[playerAddress] = 0;
            }
            approvedPlayer[playerAddress] = false;
        }
        players = newArray;
        stage = Stage.SetUp;
        c = 0;
        return number;
    }

    function widthdraw() public {
        require(address(this).balance >= registeredFunds[msg.sender], "Not enough funds in the bank");
        require(registeredFunds[msg.sender] != 0, "You Have Nothing to Withdraw");
        uint256 fund = registeredFunds[msg.sender];
        //address(this).call{value: fund}(""); 

        (bool wasSuccessful, ) = msg.sender.call{value: fund}("");
        registeredFunds[msg.sender] -= fund;
        require(wasSuccessful, "ETH transfer failed");
    }

    function getFunds() public view returns(uint256) {
        return registeredFunds[msg.sender];
    }

    function bankFunds() public view returns(uint256) {
        return address(this).balance;
    }

    function playersSize() public view returns(uint) {
        return players.length;
    }

    function randomNumber() private view returns(uint256) {
        uint256 number = 2 + uint(keccak256(abi.encodePacked(block.timestamp, block.difficulty, msg.sender))) % 11;
        return number;
    }
    function changeStateBet() public isExecutor(){
        stage = Stage.Bet;
    }
}
