# DegenContract - In-Game Token and Item Management Smart Contract

DegenContract is a Solidity smart contract that implements an in-game economy using ERC20 tokens called "Degen Tokens" and "Candies." The contract allows players to mint, trade, and withdraw Degen Tokens, claim Candies based on the number of Degen Tokens held, and use Candies to unlock unique in-game items. Players can also trade these items with each other.

## Getting Started

### Prerequisites

To interact with the DegenContract, you need the following:

1. An Ethereum wallet (e.g., MetaMask) to deploy the contract and interact with its functions.
2. An Ethereum development environment (e.g., Remix, Truffle) to deploy and test the contract.

### Deployment

1. Deploy the `DegenContract.sol` smart contract using your preferred Ethereum development environment.
2. After deployment, set the `contractOwner` address to the desired contract owner (the address that deploys the contract).

## Functionality

The DegenContract provides the following functionalities:

1. **Degen Tokens**
   - Degen Tokens are ERC20-compliant fungible tokens.
   - The contract owner can mint new Degen Tokens and withdraw them from the contract.
   - Players can trade Degen Tokens with each other using the `tradeTokens` function.

2. **Candies**
   - Players can claim Candies based on the number of Degen Tokens they hold.
   - Once a player reaches the `candyThreshold`, they can claim Candies and unlock in-game items.
   - Players can trade Candies with each other using the `tradeCandies` function.

3. **In-Game Items**
   - The contract has a list of available in-game items, each represented by an `Item` struct.
   - Players can purchase available items using Degen Tokens, and the contract owner receives the payment.
   - Exclusive items can only be purchased with Candies.
   - Players can also sell back their purchased items to the contract for Degen Tokens.

4. **Unlocking Items**
   - Once players reach the `candyThreshold`, they can unlock in-game items using their Candies.
   - The actual unlocking of items is assumed to be done externally, interacting with a game contract or logic.

5. **Trading Items**
   - Players can trade their owned in-game items with each other using the `tradeItems` function.

6. **Transferring Candies**
   - Players can transfer Candies to other addresses using the `transferCandies` function.
   - The allowance mechanism is implemented for Candies as well, enabling users to transfer Candies from one address to another using the `transferFromCandies` function.

## Usage Examples

1. Minting Degen Tokens:
   - Call the `mintTokens` function, providing the number of tokens to mint as an argument.

2. Claiming Candies:
   - When the player's Degen Tokens reach the `candyThreshold`, call the `claimCandies` function to claim Candies.

3. Purchasing Items:
   - Call the `purchaseItem` function with the desired item ID to purchase the item using Degen Tokens.
   - For exclusive items, ensure the player has enough Candies before calling the function.

4. Selling Items:
   - Call the `sellItem` function to sell back the purchased item and receive Degen Tokens.

5. Trading Items:
   - Use the `tradeItems` function to trade items between two players.

6. Transferring Candies:
   - Transfer Candies to other players using the `transferCandies` function.
   - Allow other players to transfer Candies from your address using the `approve` and `transferFromCandies` functions.

## Development and Testing

The contract has been tested on Ethereum development environments like Remix and Truffle. Extensive testing is crucial before deploying the contract on the mainnet. Consider using testnets for initial deployment and testing.

## Authors
Shreyanshi Mishra shreyanshimishra7689@gmail.com

## License

This project is licensed under the MIT License - see the LICENSE.md file for details.
