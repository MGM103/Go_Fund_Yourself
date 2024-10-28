# Go Fund Yourself!💰

### Description

Go Fund Yourself is an extension to the 'Fund Me' project in the Cyfrin Updraft [Foundry Fundamentals](https://updraft.cyfrin.io/courses/foundry) course.

This project presents implements a kick-starter-esque funding model using smart contracts. Individuals can permissionlessly create a fund-raise for any cause of their choice and also donate to any of the other causes created by other uses. The funds for these raises are stored and distributed via interacting with the `FundMe` smart contract.

Additionally, a frontend for the smart contract has been created to allow users to interact with the smart contract with ease.

## Table of contents

- [Go Fund Yourself!💰](#go-fund-yourself)
  - [Description](#description)
  - [Table of contents](#table-of-contents)
  - [Getting Started](#getting-started)
    - [Requirements:](#requirements)
    - [Quickstart:](#quickstart)
  - [Usage](#usage)
    - [Deploying locally](#deploying-locally)
    - [Deploying on a testnet or mainnet](#deploying-on-a-testnet-or-mainnet)
  - [Testing](#testing)
    - [Unit tests](#unit-tests)
    - [Test Coverage](#test-coverage)
  - [Additional Notes](#additional-notes)
  - [Acknowledgements](#acknowledgements)

## Getting Started

### Requirements:

The following must be installed on your machine:

- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git/)
- [foundry](https://book.getfoundry.sh/getting-started/installation)

### Quickstart:

```
git clone https://github.com/MGM103/Go_Fund_Yourself.git
cd Go_Fund_Yourself
make
```

## Usage

### Deploying locally

In one terminal run anvil. Anvil is a local Ethereum node, designed for development with Forge, akin to Ganache.

```
anvil
```

In another terminal run the following command to run the deploy script:

```
make localBlockchainSetup
```

This command will deploy the contracts and perform basic interactions ensuring that there is data that can be observed on the frontend.

If you would like to run the frontend locally, you can use the command:

```
cd frontend && npm run dev
```

_Please note that anvil must be running for interactions on the frontend to work properly_

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
