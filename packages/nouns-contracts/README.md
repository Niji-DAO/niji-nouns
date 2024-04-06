# @nouns/contracts

## Background

Nouns are an experimental attempt to improve the formation of on-chain avatar communities. While projects such as CryptoPunks have attempted to bootstrap digital community and identity, Nouns attempt to bootstrap identity, community, governance and a treasury that can be used by the community for the creation of long-term value.

One Noun is generated and auctioned every day, forever. All Noun artwork is stored and rendered on-chain. See more information at [niji-nouns.wtf](https://niji-nouns.wtf/).

## Niji Nouns Contract

| Contract                      | Address                                    | TxHash                                                                 |
|-------------------------------|--------------------------------------------|------------------------------------------------------------------------|
| NFTDescriptorV2               | 0xa4DE070095cc8fb929d7cAE9E934262dA1b38Ff7 | 0x1aae43c2a0d44c4a31fbc8399ef0288825edeb79f4d9e3bc5ecd465042950d49 |
| SVGRenderer                   | 0xD39ee1EabD3F14Ff834A12d42404305e6336dF0e | 0x5910709ec56c5142d61ee91efbc1bedf37720bd79c826e2fc4d9cd3ea97f5649 |
| NounsDescriptorV2             | 0x9464FEddD5BB0252792e2214De94F961e22737a1 | 0x358b32e9080032e4d2b07cecab2e616a334189ca57397dce6880346e2fdeb1c6 |
| Inflator                      | 0xa6b7C913E8db7a95083b81f5203E62531B3dAC75 | 0x94be0a1ede0dd381eebc14ae7627de0c361c6e2525806ba6f1e165ce73695651 |
| NounsArt                      | 0x15eDc3a4B3067a83a17627b881D37AC3546C1Dd3 | 0x64c4afbb2a36aea9ad3efa93882550ff44921957987735a6896715f8d283130e |
| NounsSeeder                   | 0xE536ed9c4578a5Af8F8E155bB41EE65f3d89BBcb | 0x22b5779827438cac858e97f4b6637466ab6e343a5e8cd57e0e91c460392272e2 |
| NounsToken                    | 0x58569d9954C834a1ca94996057B1C4f1D867F2cC | 0xa5062030d6ec4416882432291479b73c03b6a998e42f33af8334ecd993b63672 |
| NounsAuctionHouse             | 0xdff9D2434Bf9F4fFf1D98a5948e89A21008f00d7 | 0x0bcfedb5a5259433bc3c4a73516b3696db22210edbddc04ae273a16ee1c2bc8f |
| NounsAuctionHouseProxyAdmin   | 0x977D9adCf5ee86858d08A40059a2cb38B3480a73 | 0x093beca96e84ef4a29ee1d4896d573fd65db9477d23ab93cf3bbd883d5f2f49c |
| NounsAuctionHouseProxy        | 0x41e3762D510D66e0EdE91D10961f59ce37b2C42B | 0x4ad4a25cf7506aeb96f7339a5761d1b6f855bc49c30f8c1b1874b7adcb1abc35 |
| NounsDAOExecutor              | 0xdCB8Cbd509C470E33aaEa84284f617644665D690 | 0x03e7585f43402cba6b837464f69794c9c37d3661bf6eec0e5a2fd6f811f3c113 |
| NounsDAOLogicV2               | 0xFF6Cb4138ea9912FeDc3478b6103EaAE4B8Aa6F1 | 0x4d76e7ade83a6014e6d40290e4e04556c3c172ae7a90c7f8cb58eb018a249f20 |
| NounsDAOProxyV2               | 0x5CbB3beB69055ceC3361f2c2DA759a0920ff59de | 0x405b76f1ab35f4fe1113666a0afa997d0cdfc43fb41da0ca146a8eb6d8a9484b |



## Contracts

| Contract                                                        | Description                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             | Address                                                                                                               |
| --------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | --------------------------------------------------------------------------------------------------------------------- |
| [NounsToken](./contracts/NounsToken.sol)                        | This is the Nouns ERC721 Token contract. Unlike other Nouns contracts, it cannot be replaced or upgraded. Beyond the responsibilities of a standard ERC721 token, it is used to lock and replace periphery contracts, store checkpointing data required by our Governance contracts, and control Noun minting/burning. This contract contains two main roles - `minter` and `owner`. The `minter` will be set to the Nouns Auction House in the constructor and ownership will be transferred to the Nouns DAO following deployment.                                                                                                    | [0x9C8fF314C9Bc7F6e59A9d9225Fb22946427eDC03](https://etherscan.io/address/0x9C8fF314C9Bc7F6e59A9d9225Fb22946427eDC03) |
| [NounsSeeder](./contracts/NounsSeeder.sol)                      | This contract is used to determine Noun traits during the minting process. It can be replaced to allow for future trait generation algorithm upgrades. Additionally, it can be locked by the Nouns DAO to prevent any future updates. Currently, Noun traits are determined using pseudo-random number generation: `keccak256(abi.encodePacked(blockhash(block.number - 1), nounId))`. Trait generation is not truly random. Traits can be predicted when minting a Noun on the pending block.                                                                                                                                          | [0xCC8a0FB5ab3C7132c1b2A0109142Fb112c4Ce515](https://etherscan.io/address/0xCC8a0FB5ab3C7132c1b2A0109142Fb112c4Ce515) |
| [NounsDescriptor](./contracts/NounsDescriptor.sol)              | This contract is used to store/render Noun artwork and build token URIs. Noun 'parts' are compressed in the following format before being stored in their respective byte arrays: `Palette Index, Bounds [Top (Y), Right (X), Bottom (Y), Left (X)] (4 Bytes), [Pixel Length (1 Byte), Color Index (1 Byte)][]`. When `tokenURI` is called, Noun parts are read from storage and converted into a series of SVG rects to build an SVG image on-chain. Once the entire SVG has been generated, it is base64 encoded. The token URI consists of base64 encoded data URI with the JSON contents directly inlined, including the SVG image. | [0x0Cfdb3Ba1694c2bb2CFACB0339ad7b1Ae5932B63](https://etherscan.io/address/0x0Cfdb3Ba1694c2bb2CFACB0339ad7b1Ae5932B63) |
| [NounsAuctionHouse](./contracts/NounsAuctionHouse.sol)          | This contract acts as a self-sufficient noun generation and distribution mechanism, auctioning one noun every 24 hours, forever. 100% of auction proceeds (ETH) are automatically deposited in the Nouns DAO treasury, where they are governed by noun owners. Each time an auction is settled, the settlement transaction will also cause a new noun to be minted and a new 24 hour auction to begin. While settlement is most heavily incentivized for the winning bidder, it can be triggered by anyone, allowing the system to trustlessly auction nouns as long as Ethereum is operational and there are interested bidders.       | [0xF15a943787014461d94da08aD4040f79Cd7c124e](https://etherscan.io/address/0xF15a943787014461d94da08aD4040f79Cd7c124e) |
| [NounsDAOExecutor](./contracts/governance/NounsDAOExecutor.sol) | This contract is a fork of Compound's `Timelock`. It acts as a timelocked treasury for the Nouns DAO. This contract is controlled by the governance contract (`NounsDAOProxy`).                                                                                                                                                                                                                                                                                                                                                                                                                                                         | [0x0BC3807Ec262cB779b38D65b38158acC3bfedE10](https://etherscan.io/address/0x0BC3807Ec262cB779b38D65b38158acC3bfedE10) |
| [NounsDAOProxy](./contracts/governance/NounsDAOProxy.sol)       | This contract is a fork of Compound's `GovernorBravoDelegator`. It can be used to create, vote on, and execute governance proposals.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    | [0x6f3E6272A167e8AcCb32072d08E0957F9c79223d](https://etherscan.io/address/0x6f3E6272A167e8AcCb32072d08E0957F9c79223d) |
| [NounsDAOLogicV1](./contracts/governance/NounsDAOLogicV1.sol)   | This contract is a fork of Compound's `GovernorBravoDelegate`. It's the logic contract used by the `NounsDAOProxy`.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     | [0xa43aFE317985726E4e194eb061Af77fbCb43F944](https://etherscan.io/address/0xa43aFE317985726E4e194eb061Af77fbCb43F944) |

## Development

### Install dependencies

```sh
yarn
```

### Compile typescript, contracts, and generate typechain wrappers

```sh
yarn build
```

### Run tests

```sh
yarn test
```

### Install forge dependencies

```sh
forge install
```

### Run forge tests

```sh
forge test -vvv
```

### Environment Setup

Copy `.env.example` to `.env` and fill in fields

### Commands

```sh
# Compile Solidity
yarn build:sol

# Command Help
yarn task:[task-name] --help

# Deploy & Configure for Local Development (Hardhat)
yarn task:run-local

# Deploy & Configure (Testnet/Mainnet)
# This task deploys and verifies the contracts, populates the descriptor, and transfers contract ownership.
# For parameter and flag information, run `yarn task:deploy-and-configure --help`.
yarn task:deploy-and-configure --network [network] --update-configs
```

### Automated Testnet Deployments

The contracts are deployed to Rinkeby on each push to master and each PR using the account `0x387d301d92AE0a87fD450975e8Aef66b72fBD718`. This account's mnemonic is stored in GitHub Actions as a secret and is injected as the environment variable `MNEMONIC`. This mnemonic _shouldn't be considered safe for mainnet use_.
