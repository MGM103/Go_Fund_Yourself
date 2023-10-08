# Go Fund Yourself!💰

### Description

Go Fund Yourself was an educational project I undertook to better understand solidity and the Foundry smart contract development framework. This project presents implements a kick-starter-esque funding model using smart contracts. The owner can deploy the Go Fund Yourself Contracts and allow other users to deposit funds into the contract to collect funds for a cause. The owner and only the owner of the contracts can then withdraw the funds to use them else where.

## Table of contents
1. [Getting started](#getting-started)
   * [1.1 Requirements](#requirements) 
   * [1.2 Quickstart](#quickstart)
2. [Usage](#usage)
   * [2.1 Deploying Locally](#deploying-locally)
   * [2.2 Deploying on a testnet or mainnet](#deploying-on-a-testnet-or-mainnet)
3. [Testing](#testing)
   * [3.1 Unit tests](#unit-tests)
   * [3.2 Coverage](#test-coverage)
4. [Additional Notes](#additional-notes)
5. [Acknowledgements](#acknowledgements)

## Getting Started

### Requirements:
The following must be installed on your machine:
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git/)
- [foundry](https://book.getfoundry.sh/getting-started/installation)

### Quickstart:
```
git clone https://github.com/MGM103/Go_Fund_Yourself.git
cd Go_Fund_Yourself
forge build
```

## Usage
### Deploying locally
In one terminal run anvil. Anvil is a local Ethereum node, designed for development with Forge, akin to Ganache.
```
anvil
```

In another terminal run the following command to run the deploy script:
```
forge script script/DeployFundMe.s.sol --rpc-url http://127.0.0.1:8545 --private-key <privateKey> --broadcast
```

### Deploying on a testnet or mainnet
You should create a .env file with values for a private key and rpc url and optionally an etherscan api key as below:
```env
PRIVATE_KEY=<YOUR_PRIVATE_KEY>
<NETWORK>_RPC_URL=<YOUR_RPC_URL>
ETHERSCAN_API_KEY=<YOUR_ETHERSCAN_API_KEY>
```
**Please be carfeful when entering a private key in plain text! Unless deploying into production, please use a development account with no valuable funds in it.**

Deploy using the following command:
```
forge script script/DeployFundMe.s.sol --rpc-url $<NETWORK>_RPC_URL --private-key $PRIVATE_KEY --broadcast --verify --etherscan-api-key $ETHERSCAN_API_KEY
```

## Testing

### Unit tests
To run the unit tests for this project you can run the following commands:
```
forge test // run all tests
forge test --mt <testFunctionName> // run specific test
```

### Test Coverage
To see the amount of coverage the tests in the project cover of the codebase you can run the following command:
```
forge coverage
```

## Additional Notes

If you are unfamiliar with the foundry smart contract development framework please refer to: https://book.getfoundry.sh/

## Acknowledgements

Full credit must go to [Patrick Collins](https://github.com/PatrickAlphaC). He is a fantastic teacher of blockchain development and this project came from his [course](https://github.com/Cyfrin/foundry-full-course-f23). If you are interested in learning more please checkout his [youtube](https://www.youtube.com/@PatrickAlphaC).
