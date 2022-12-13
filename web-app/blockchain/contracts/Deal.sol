
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract Deal {
	struct Product
	{
		string name;
		uint quantity;
		uint price; // Price per single product.
	}

	struct Shipment
	{
		address payable courierAddr;
		uint price;
		uint date;
	}

	struct Order
	{
		Product product;
		Shipment shipment;
		uint total;
		bool initialized;
	}

	address public buyerAddr; // payable - Enable sending money to them.
	address payable public sellerAddr; // payable - Enable sending money to them.

	mapping (uint => Order) public orders;
	uint public orderCount;

	event OnOrderPlaced(address buyerAddr, string product, uint quantity, uint orderNumber);

	constructor(address buyer) {
		sellerAddr = payable(msg.sender);
		buyerAddr = buyer;
		orderCount = 0;
	}

	function placeOrder(string calldata product, uint quantity, address courierAddr) public payable {
		require(sellerAddr == msg.sender);

		uint total = 10 * quantity + 5;

		orders[orderCount] = Order(
			Product(product, quantity, 10),
			Shipment(payable(courierAddr), 5, block.timestamp),
			total,
			true
		);

		uint id = orderCount;
		orderCount++;

		emit OnOrderPlaced(
			buyerAddr,
			product,
			quantity,
			id
		);
	}

	function getOrder(uint number) view public returns(address buyer, string memory product, uint quantity, uint total, uint date) {
		require(orders[number].initialized);

		return (
			buyerAddr,
			orders[number].product.name,
			orders[number].product.quantity,
			orders[number].product.price,
			orders[number].shipment.date
		);
	}
}
