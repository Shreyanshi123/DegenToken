// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DegenContract is ERC20 {
    // Contract owner's address
    address public contractOwner;
    // Threshold of Degen Tokens required to claim Candies
    uint256 public candyThreshold;

    // Mapping to track the number of Candies owned by each address
    mapping(address => uint256) public candies;
    // Mapping to track if an address has already unlocked an item
    mapping(address => bool) public hasUnlockedItem;
    // Mapping to track the purchased item ID for each address
    mapping(address => uint256) public purchasedItems;

    // Events to emit when certain actions are performed
    event ItemUnlocked(address indexed user);
    event CandyTraded(address indexed from, address indexed to, uint256 amount);
    event ItemPurchased(address indexed user, uint256 itemId, uint256 price);
    event ItemSold(address indexed seller, address indexed buyer, uint256 itemId, uint256 price);
    event ItemsTraded(address indexed address1, address indexed address2, uint256 itemId1, uint256 itemId2);

    // Structure to represent an in-game item
    struct Item {
        string name;       // Name of the item
        uint256 price;     // Price of the item in Degen Tokens
        bool isAvailable;  // Availability status of the item
        bool exclusive;    // Whether the item can be purchased with Candies exclusively
    }

    // Array to store the list of available in-game items
    Item[] public items;

    // Constructor function to initialize the contract
    constructor(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        uint256 _candyThreshold
    ) ERC20(_name, _symbol) {
        // Set the contract owner as the deployer of the contract
        contractOwner = msg.sender;
        // Mint the initial supply of Degen Tokens and assign it to the contract owner
        _mint(msg.sender, _initialSupply);
        // Set the threshold of Degen Tokens required to claim Candies
        candyThreshold = _candyThreshold;

        // Add available items and their costs here
        items.push(Item("Pets", 5 ether, true, false));
        items.push(Item("Hats", 3 ether, true, false));
        items.push(Item("Mounts", 8 ether, true, false));
        items.push(Item("Enchantments for Swords", 12 ether, true, false));
        items.push(Item("Swords", 10 ether, true, true));
        items.push(Item("Potions", 2 ether, true, true));
        items.push(Item("Armors", 4 ether, true, true));
        items.push(Item("Gems", 3 ether, true, true));

        // Add more items here
        items.push(Item("Shields", 6 ether, true, false));
        items.push(Item("Magical Wands", 15 ether, true, false));
        items.push(Item("Flying Brooms", 7 ether, true, false));
        items.push(Item("Invisibility Cloaks", 9 ether, true, false));
        items.push(Item("Super Potions", 3 ether, true, true));
        items.push(Item("Powerful Armors", 8 ether, true, true));
        items.push(Item("Legendary Gems", 12 ether, true, true));
    }

    // Modifier to ensure that only the contract owner can execute certain functions
    modifier onlyOwner() {
        require(msg.sender == contractOwner, "Only the contract owner can call this function");
        _;
    }

    // Function to trade Degen Tokens between two addresses
    function tradeTokens(address to, uint256 amount) external {
        require(amount <= balanceOf(msg.sender), "Insufficient balance");
        _transfer(msg.sender, to, amount);
    }

    // Function for the contract owner to mint new Degen Tokens
    function mintTokens(uint256 amount) external onlyOwner {
        _mint(contractOwner, amount);
    }

    // Function for the contract owner to withdraw Degen Tokens from the contract
    function withdrawTokens(uint256 amount) external onlyOwner {
        require(amount <= balanceOf(contractOwner), "Insufficient contract owner balance");
        _transfer(contractOwner, msg.sender, amount);
    }

    // Function for users to claim Candies by holding a certain number of Degen Tokens
    function claimCandies() external {
        require(balanceOf(msg.sender) >= candyThreshold, "Insufficient tokens to claim candies");
        require(!hasUnlockedItem[msg.sender], "You have already unlocked an item");

        // Increment the number of Candies owned by the user
        candies[msg.sender]++;

        // Check if the user has reached the threshold to unlock an item
        if (candies[msg.sender] >= candyThreshold) {
            // Set the flag to indicate that the user has unlocked an item
            hasUnlockedItem[msg.sender] = true;
            // Emit an event to notify that an item has been unlocked for the user
            emit ItemUnlocked(msg.sender);
        }
    }

    // Function for users to trade Candies with each other
    function tradeCandies(address to, uint256 amount) external {
        require(candies[msg.sender] >= amount, "Insufficient candies");
        // Subtract the traded candies from the sender and add them to the receiver
        candies[msg.sender] -= amount;
        candies[to] += amount;
        // Emit an event to notify the candy trade between addresses
        emit CandyTraded(msg.sender, to, amount);
    }

    // Function to unlock an in-game item after reaching the candy threshold
    function unlockItem() external {
        require(hasUnlockedItem[msg.sender], "You haven't unlocked an item yet");

        // Add the logic to unlock the specific in-game item here.
        // This could involve interacting with a game contract or any other relevant logic.
        // For the sake of simplicity, we'll assume it's done externally.

        // Once the item is unlocked, you can choose to reset the candies count for the user.
        candies[msg.sender] = 0;
        hasUnlockedItem[msg.sender] = false;
    }

    // Function to get the total number of available in-game items
    function getNumberOfItems() external view returns (uint256) {
        return items.length;
    }

    // Function to get the name of an item based on its ID
    function getItemName(uint256 itemId) external view returns (string memory) {
        require(itemId < items.length, "Invalid item ID");
        return items[itemId].name;
    }

    // Function for users to purchase in-game items using Degen Tokens
    function purchaseItem(uint256 itemId) external {
        require(itemId < items.length, "Invalid item ID");
        Item storage item = items[itemId];
        require(item.isAvailable, "Item not available for purchase");
        require(balanceOf(msg.sender) >= item.price, "Insufficient tokens to purchase");

        // Check if the item is exclusive and requires Candies for purchase
        if (item.exclusive) {
            require(balanceOf(msg.sender) >= candyThreshold, "Insufficient candies to purchase exclusive item");
            // Deduct the item price in Candies from the user's candies count
            candies[msg.sender] += item.price;
        } else {
            // Transfer the item price in Degen Tokens to the contract owner
            _transfer(msg.sender, contractOwner, item.price);
        }

        // Record the purchased item for the user
        purchasedItems[msg.sender] = itemId;
        // Mark the item as unavailable for others to purchase until the user decides to sell it
        item.isAvailable = false;
        // Emit an event to notify the purchase of the item
        emit ItemPurchased(msg.sender, itemId, item.price);
    }

    // Function for users to sell back their purchased item and receive Degen Tokens as payment
    function sellItem(uint256 price) external {
        require(purchasedItems[msg.sender] < items.length, "No purchased item to sell");
        Item storage item = items[purchasedItems[msg.sender]];
        require(!item.isAvailable, "Item is already available for purchase");

        // Transfer the selling price in Degen Tokens from the contract owner to the user
        _transfer(contractOwner, msg.sender, price);
        // Mark the item as available for others to purchase
        item.isAvailable = true;
        // Emit an event to notify the sale of the item
        emit ItemSold(contractOwner, msg.sender, purchasedItems[msg.sender], price);
    }

    // Function for users to trade their owned items with each other
    function tradeItems(address address1, uint256 itemId1, address address2, uint256 itemId2) external {
        require(address1 != address(0) && address2 != address(0), "Invalid addresses");
        require(itemId1 < items.length && itemId2 < items.length, "Invalid item IDs");

        // Check if both addresses own the items they want to trade
        require(purchasedItems[address1] == itemId1, "Address1 does not own the item to trade");
        require(purchasedItems[address2] == itemId2, "Address2 does not own the item to trade");

        // Execute the trade by swapping the items
        purchasedItems[address1] = itemId2;
        purchasedItems[address2] = itemId1;

        // Emit an event to notify the trade of items between addresses
        emit ItemsTraded(address1, address2, itemId1, itemId2);
    }

    // Function for users to transfer Candies to other addresses
    function transferCandies(address to, uint256 amount) external {
        require(candies[msg.sender] >= amount, "Insufficient candies");
        // Subtract the transferred candies from the sender and add them to the receiver
        candies[msg.sender] -= amount;
        candies[to] += amount;
        // Emit an event to notify the candy transfer between addresses
        emit CandyTraded(msg.sender, to, amount);
    }

    // Function for users to transfer Candies from one address to another using the allowance mechanism
    function transferFromCandies(address from, address to, uint256 amount) external {
        require(candies[from] >= amount, "Insufficient candies");
        // Subtract the transferred candies from the sender and add them to the receiver
        candies[from] -= amount;
        candies[to] += amount;
        // Emit an event to notify the candy transfer between addresses
        emit CandyTraded(from, to, amount);
    }
}
