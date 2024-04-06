import { Interface } from 'ethers/lib/utils';
import { task, types } from 'hardhat/config';
import promptjs from 'prompt';
import { default as NounsAuctionHouseABI } from '../abi/contracts/NounsAuctionHouse.sol/NounsAuctionHouse.json';
import { ChainId, ContractDeployment, ContractNameNijiNouns, DeployedContract } from './types';
import { createSigner } from './utils/createSigner';

promptjs.colors = false;
promptjs.message = '> ';
promptjs.delimiter = '';

const proxyRegistries: Record<number, string> = {
  [ChainId.Mainnet]: '0xa5409ec958c83c3f309868babaca7c86dcb077c1',
  [ChainId.Rinkeby]: '0xf57b2c51ded3a29e6891aba85459d600256cf317',
};
const wethContracts: Record<number, string> = {
  [ChainId.AstarZkEVM]: '0xE9CC37904875B459Fa5D0FE37680d36F1ED55e38.',
  [ChainId.ZKyoto]: '0xE9CC37904875B459Fa5D0FE37680d36F1ED55e38',
};

const NOUNS_ART_NONCE_OFFSET = 4;
const AUCTION_HOUSE_PROXY_NONCE_OFFSET = 9;
const GOVERNOR_N_DELEGATOR_NONCE_OFFSET = 12;

task('nigi-deploy', 'Deploys NFTDescriptor, NounsDescriptor, NounsSeeder, and NounsToken')
  .addOptionalParam('weth', 'The WETH contract address', undefined, types.string)
  .addOptionalParam('noundersdao', 'The nounders DAO contract address', undefined, types.string)
  .addOptionalParam('vetoer', 'The vetoer address', undefined, types.string)
  .addOptionalParam(
    'auctionTimeBuffer',
    'The auction time buffer (seconds)',
    5 * 60 /* 5 minutes */,
    types.int,
  )
  .addOptionalParam(
    'auctionReservePrice',
    'The auction reserve price (wei)',
    1 /* 1 wei */,
    types.int,
  )
  .addOptionalParam(
    'auctionMinIncrementBidPercentage',
    'The auction min increment bid percentage (out of 100)',
    2 /* 2% */,
    types.int,
  )
  .addOptionalParam(
    'auctionBaseDuration',
    'The auction base duration (seconds)',
    60 * 60 * 24 /* 24 hours */,
    types.int,
  )
  .addOptionalParam(
    'timelockDelay',
    'The timelock delay (seconds)',
    60 * 60 * 24 * 2 /* 2 days */,
    types.int,
  )
  .addOptionalParam(
    'votingPeriod',
    'The voting period (blocks)',
    Math.round(4 * 60 * 24 * (60 / 13)) /* 4 days (13s blocks) */,
    types.int,
  )
  .addOptionalParam(
    'votingDelay',
    'The voting delay (blocks)',
    Math.round(3 * 60 * 24 * (60 / 13)) /* 3 days (13s blocks) */,
    types.int,
  )
  .addOptionalParam('proposalThreshold', 'The proposal threshold', 1, types.int)
  .addOptionalParam(
    'minQuorumVotesBPS',
    'Min basis points input for dynamic quorum',
    1_000,
    types.int,
  ) // Default: 10%
  .addOptionalParam(
    'maxQuorumVotesBPS',
    'Max basis points input for dynamic quorum',
    1_500,
    types.int,
  ) // Default: 15%
  .addOptionalParam('quorumCoefficient', 'Dynamic quorum coefficient (float)', 1, types.float)
  .setAction(async (args, { ethers }) => {
    const network = await ethers.provider.getNetwork();
    console.log(`network: ${JSON.stringify(network)}`);
    const deployer = createSigner(ethers.provider);

    // prettier-ignore
    const proxyRegistryAddress = proxyRegistries[network.chainId] ?? proxyRegistries[ChainId.Rinkeby];
    console.log(args);

    if (!args.noundersdao) {
      console.log(
        `Nounders DAO address not provided. Setting to deployer (${deployer.address})...`,
      );
      args.noundersdao = deployer.address;
    }
    if (!args.vetoer) {
      console.log(`Vetoer address not provided. Setting to deployer (${deployer.address})...`);
      args.vetoer = deployer.address;
    }

    if (!args.weth) {
      const deployedWETHContract = wethContracts[network.chainId];
      if (!deployedWETHContract) {
        throw new Error(
          `Can not auto-detect WETH contract on chain ${network.name}. Provide it with the --weth arg.`,
        );
      }
      args.weth = deployedWETHContract;
    }

    const nonce = await ethers.provider.getTransactionCount(deployer.address);
    const expectedNounsArtAddress = ethers.utils.getContractAddress({
      from: deployer.address,
      nonce: nonce + NOUNS_ART_NONCE_OFFSET,
    });
    const expectedAuctionHouseProxyAddress = ethers.utils.getContractAddress({
      from: deployer.address,
      nonce: nonce + AUCTION_HOUSE_PROXY_NONCE_OFFSET,
    });
    const expectedNounsDAOProxyAddress = ethers.utils.getContractAddress({
      from: deployer.address,
      nonce: nonce + GOVERNOR_N_DELEGATOR_NONCE_OFFSET,
    });
    const deployment: Record<ContractNameNijiNouns, DeployedContract> = {} as Record<
      ContractNameNijiNouns,
      DeployedContract
    >;
    const contracts: Record<ContractNameNijiNouns, ContractDeployment> = {
      NFTDescriptorV2: {},
      SVGRenderer: {},
      NounsDescriptorV2: {
        args: [expectedNounsArtAddress, () => deployment.SVGRenderer.address],
        libraries: () => ({
          NFTDescriptorV2: deployment.NFTDescriptorV2.address,
        }),
      },
      Inflator: {},
      NounsArt: {
        args: [() => deployment.NounsDescriptorV2.address, () => deployment.Inflator.address],
      },
      NounsSeeder: {},
      NounsToken: {
        args: [
          args.noundersdao,
          expectedAuctionHouseProxyAddress,
          () => deployment.NounsDescriptorV2.address,
          () => deployment.NounsSeeder.address,
          proxyRegistryAddress,
        ],
      },
      NounsAuctionHouse: {},
      NounsAuctionHouseProxyAdmin: {},
      NounsAuctionHouseProxy: {
        args: [
          () => deployment.NounsAuctionHouse.address,
          () => deployment.NounsAuctionHouseProxyAdmin.address,
          () =>
            new Interface(NounsAuctionHouseABI).encodeFunctionData('initialize', [
              deployment.NounsToken.address,
              args.weth,
              args.auctionTimeBuffer,
              args.auctionReservePrice,
              args.auctionMinIncrementBidPercentage,
              args.auctionBaseDuration,
            ]),
        ],
        validateDeployment: () => {
          const expected = expectedAuctionHouseProxyAddress.toLowerCase();
          const actual = deployment.NounsAuctionHouseProxy.address.toLowerCase();
          if (expected !== actual) {
            throw new Error(
              `Unexpected auction house proxy address. Expected: ${expected}. Actual: ${actual}.`,
            );
          }
        },
      },
      NounsDAOExecutor: {
        args: [expectedNounsDAOProxyAddress, args.timelockDelay],
      },
      NounsDAOLogicV2: {},
      NounsDAOProxyV2: {
        args: [
          () => deployment.NounsDAOExecutor.address,
          () => deployment.NounsToken.address,
          args.vetoer,
          () => deployment.NounsDAOExecutor.address,
          () => deployment.NounsDAOLogicV2.address,
          args.votingPeriod,
          args.votingDelay,
          args.proposalThreshold,
          {
            minQuorumVotesBPS: args.minQuorumVotesBPS,
            maxQuorumVotesBPS: args.maxQuorumVotesBPS,
            quorumCoefficient: ethers.utils.parseUnits(args.quorumCoefficient.toString(), 6),
          },
        ],
        validateDeployment: () => {
          const expected = expectedNounsDAOProxyAddress.toLowerCase();
          const actual = deployment.NounsDAOProxyV2.address.toLowerCase();
          if (expected !== actual) {
            throw new Error(
              `Unexpected Nouns DAO proxy address. Expected: ${expected}. Actual: ${actual}.`,
            );
          }
        },
      },
    };

    for (const [name, contract] of Object.entries(contracts)) {
      const factory = (
        await ethers.getContractFactory(name, {
          libraries: contract?.libraries?.(),
        })
      ).connect(deployer);

      console.log('deploying', name);
      const deployedContract = await factory.deploy(
        ...(contract.args?.map(a => (typeof a === 'function' ? a() : a)) ?? []),
      );

      await deployedContract.deployed();

      deployment[name as ContractNameNijiNouns] = {
        name,
        instance: deployedContract,
        address: deployedContract.address,
        constructorArguments: contract.args?.map(a => (typeof a === 'function' ? a() : a)) ?? [],
        libraries: contract?.libraries?.() ?? {},
      };

      contract.validateDeployment?.();

      const gasFee = deployedContract?.deployTransaction.maxFeePerGas?.mul(
        deployedContract?.deployTransaction?.gasLimit,
      );
      console.log(
        `${name} contract deployed to ${deployedContract.address} from ${
          deployedContract.deployTransaction.from
        } with ${ethers.utils.formatUnits(gasFee ?? 0, 'ether')} ETH`,
      );
      console.log(`args: ${contract.args?.map(a => (typeof a === 'function' ? a() : a)) ?? []}`);
    }

    return deployment;
  });
