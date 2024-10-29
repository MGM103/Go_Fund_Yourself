# Go Fund Yourself Front End

### Description

The frontend for this onchain app was created using SvelteKit. The `wagmi` library is powering the client-side onchain aspects of the app. More details on the SvelteKit variation of `wagmi` can be found [here](https://github.com/softwarecurator/svelte-wagmi). Svelte wagmi is built on top of [@wagmi/core](https://wagmi.sh/core/getting-started). The server-side onchain capabilities of this app are powered by `viem`, more info can be found [here](https://viem.sh/docs/getting-started).

Additionally, the app stores some data about each of the fund-raises off-chain. A sqlite db is used to store descriptions about each fund-raise, to give some insight as to why the user is asking for funds.

As of writing the app is live at the following url: [gofundyourself.cash](gofundyourself.cash).

## Table of contents

- [Go Fund Yourself Front End](#go-fund-yourself-front-end)
  - [Description](#description)
  - [Table of contents](#table-of-contents)
  - [Frontend Setup](#frontend-setup)
    - [Required Env Vars](#required-env-vars)
    - [Required Dependencies](#required-dependencies)
  - [Local Dev](#local-dev)
  - [Building](#building)
  - [Docker](#docker)

## Frontend Setup

### Required Env Vars

The FE requires `.env` with the values shown below:

```
DB_PATH=<db_filepath>
PUBLIC_WALLETCONNECT_ID=<walletconnect_id>
SEPOLIA_RPC_URL=<sepolia_rpc_url>
```

The db path is used in the `database.js` file to create a new instance of a db. This project is using better-sqlite3 for sqlite db operations and configuration.

The `wagmi` library requires a wallet connect project id on initialisation. This can be provided here in the `.env` file.

We are using `viem` to pull onchain data on the server to then use in our components. This requires a rpc to perform this action when on a mainnet or testnet. Currently this project is configured to run on either `anvil` or `sepolia`. `anvil` for local dev and `sepolia` for 'prod'.

### Required Dependencies

Install the frontend dependencies using the following command:

```bash
npm install
```

## Local Dev

Once you've created a project and installed dependencies with `npm install` (or `pnpm install` or `yarn`), start a development server:

```bash
npm run dev

# or start the server and open the app in a new browser tab
npm run dev -- --open
```

## Building

To create a production version of your app:

```bash
npm run build
```

You can preview the production build with `npm run preview`.

## Docker

A `dockerfile` has been provided to for the FE to create an image of the fe to allow it run on a server. Currently this app is running on a VPS.

The make file in the root of the directory contains the commands for building and running the docker image.

Additionally, there is a `docker-compose.yml` that sets up the containerised FE and a `watchtower` instance to monitor for new versions of the container and will update the FE on the VPS if a new version is detected.
