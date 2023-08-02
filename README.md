## DegenToken Smart Contract ##

## Features##
-The DegenToken smart contract is an ERC20 token contract with additional functionalities to handle unique Candy tokens and game store purchases.

-It allows the contract owner to mint new Degen tokens for players as rewards and simultaneously mint a new unique Candy token with custom attributes.

-The contract owner can set prices for different types of items available in the game store.

-Players can purchase items from the game store using either Degen tokens or Candy tokens.

-Players can transfer Candy tokens to other addresses.

-Players can convert Candy tokens to Degen tokens at a fixed exchange rate.

-The smart contract overrides the ERC20 transfer functions to enable the transfer of Degen tokens.

-The contract owner can withdraw Degen tokens from the contract balance.

## Custom Data Structures ##
## ItemType ## 
An enumeration representing different types of items available in the game store, such as Candies, DecorativeItems, Watches, Swords, Potions, Pets, Armors, Hats, Mounts, Gems, and Enchantments.

## Candy: ##
A struct representing a unique Candy token with attributes like tokenId, name, color, shape, and texture.

## Interacting with the Contract ##
To interact with the contract, you can use any Ethereum wallet or developer tools that support the Avalanche network. Connect to the Avalanche network in your wallet or development environment and use the contract address to interact with the Degen Gaming Token. (For this Project, I have used Remix)

Go to https://remix.ethereum.org/

Load the contract in the workspace and compile it in the compile section of the Remix IDE.

In the Deploy and Run Transactions section of Remix IDE, in the environments section, select "Injected Web3" as the provider.

Note: Make sure your wallet is connected to the Avalanche testnet (Fuji) and Remix IDE.

Your accounts in your wallet will be available in the account option, and you can switch between accounts.

You can deploy your contract by clicking on the "Deploy" option or by copying the contract address from https://testnet.snowtrace.io/ and pasting it in the "At Address" field.

You can interact with functions by providing the required arguments and clicking on "Transact."

## Authors ##
Shreyanshi Mishra shreyanshimishra7689@gmail.com

## License ##
This project is licensed under the MIT License - see the LICENSE.md file for details.
