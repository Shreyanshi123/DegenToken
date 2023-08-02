// SPDX-License-Identifier: MIT
pragma solidity 0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract DegenToken is ERC20, Ownable {

    enum ItemType {
        Candies,
        DecorativeItems,
        Watches,
        Swords,
        Potions,
        Pets,
        Armors,
        Hats,
        Mounts,
        Gems,
        Enchantments
    }

    struct Candy {
        uint256 tokenId; // Unique identifier for the candy token
        string name;
        string color;
        string shape;
        string texture;
    }

   

    mapping(uint256 => Candy) private _candies;
    mapping(address => uint256) private _candyBalances; // Separate balance mapping for Candy tokens
    uint256 private _nextCandyId = 1;

    uint256 private _candyToDGNTokensExchangeRate = 10; // 10 Candy tokens = 1 DGN token

    // Map item type to its price
    mapping(ItemType => uint256) private _itemPrices;


    event TokensLocked(address indexed account, uint256 amount);
    event TokensUnlocked(address indexed account, uint256 amount);
    event ItemPurchased(address indexed account, uint256 itemId);
    event CandyTransferred(address indexed from, address indexed to, uint256 amount);
    event CandyConverted(address indexed account, uint256 candyAmount, uint256 dgnAmount);

    constructor(uint256 initialSupply) ERC20("Degen", "DGN") {
        _mint(msg.sender, initialSupply);
    }

    // Function to mint tokens for players as rewards and mint a new unique candy with attributes
    function mintTokensWithUniqueCandy(address account, uint256 amount, string memory candyName, string memory color, string memory shape, string memory texture) public onlyOwner {
        _mint(account, amount);
        _candies[_nextCandyId] = Candy(_nextCandyId, candyName, color, shape, texture);
        _nextCandyId++;
    }

    // Function to buy an item from the game store using either tokens or Candy tokens
     function purchaseItem(ItemType itemType, bool useTokens) public {
        require(itemType >= ItemType.Candies && itemType <= ItemType.Enchantments, "Invalid item type");
        uint256 price = _itemPrices[itemType];

        if (!useTokens) {
            require(_candyBalances[msg.sender] >= price, "Insufficient Candy balance");
            _candyBalances[msg.sender] -= price; // Deduct Candy tokens from the sender's balance
        }

        _transfer(msg.sender, owner(), price); // Transfer tokens or Candy tokens from the buyer to the contract owner (store)


        uint256 itemTypeAsUint = uint256(itemType);
        emit ItemPurchased(msg.sender, itemTypeAsUint);
    }

    // Function to transfer Candy tokens
    function transferCandy(address recipient, uint256 candyAmount) public {
        require(_candies[candyAmount].tokenId > 0, "Invalid candy ID");
        require(_candyBalances[msg.sender] >= candyAmount, "Insufficient Candy balance");
        _candyBalances[msg.sender] -= candyAmount;
        _candyBalances[recipient] += candyAmount;
        emit CandyTransferred(msg.sender, recipient, candyAmount);
    }

    // Function to convert Candy tokens to DGN tokens
    function convertCandyToDGN(uint256 candyAmount) public {
        require(_candies[candyAmount].tokenId > 0, "Invalid candy ID");
        require(_candyBalances[msg.sender] >= candyAmount, "Insufficient Candy balance");
        _candyBalances[msg.sender] -= candyAmount;
        uint256 dgnAmount = candyAmount / _candyToDGNTokensExchangeRate;
        _mint(msg.sender, dgnAmount); // Mint DGN tokens to the sender's address
        emit CandyConverted(msg.sender, candyAmount, dgnAmount); 
    }

    // Overrides ERC20 transfer function to allow transfer of DGN tokens
    function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    // Overrides ERC20 transferFrom function to allow transfer of DGN tokens
    function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(sender, _msgSender(), allowance(sender, _msgSender()) - amount);
        return true;
    }

    // Function to withdraw DGN tokens (Only contract owner can call this function)
    function withdraw(uint256 amount) public onlyOwner {
        require(amount <= balanceOf(address(this)), "Not enough DGN balance");
        _transfer(address(this), owner(), amount);
    }

    // Function to get the Candy balance of an address
    function getCandyBalance(address account) public view returns (uint256) {
        return _candyBalances[account];
    }

    // Function to set the exchange rate of Candy to DGN tokens
    function setCandyToDGNTokensExchangeRate(uint256 rate) public onlyOwner {
        _candyToDGNTokensExchangeRate = rate;
    }

    // Function to get the current exchange rate of Candy to DGN tokens
    function getCandyToDGNTokensExchangeRate() public view returns (uint256) {
        return _candyToDGNTokensExchangeRate;
    }

    // Function to set the prices for each item type
    function setItemPrice(ItemType itemType, uint256 price) public onlyOwner {
        _itemPrices[itemType] = price;
    }

    // Function to get the price of an item
    function getItemPrice(ItemType itemType) public view returns (uint256) {
        return _itemPrices[itemType];
    }

    // Function to get available items in the game store
    function getAvailableItems() public pure returns (ItemType[] memory) {
        ItemType[] memory items = new ItemType[](11);
        items[0] = ItemType.Candies;
        items[1] = ItemType.DecorativeItems;
        items[2] = ItemType.Watches;
        items[3] = ItemType.Swords;
        items[4] = ItemType.Potions;
        items[5] = ItemType.Pets;
        items[6] = ItemType.Armors;
        items[7] = ItemType.Hats;
        items[8] = ItemType.Mounts;
        items[9] = ItemType.Gems;
        items[10] = ItemType.Enchantments;

        return items;
    }
}
 






   