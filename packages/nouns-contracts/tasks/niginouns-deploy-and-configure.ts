import { task, types } from 'hardhat/config';
import { printContractsTable } from './utils';
import { createSigner } from './utils/createSigner';

task('nigi-deploy-and-configure', 'Deploy and configure all contracts')
  .addFlag('startAuction', 'Start the first auction upon deployment completion')
  //.addFlag('autoDeploy', 'Deploy all contracts without user interaction')
  .addFlag('updateConfigs', 'Write the deployed addresses to the SDK and subgraph configs')
  .addFlag('verifyEtherscan', 'Verify contracts on Etherscan')
  .addOptionalParam('weth', 'The WETH contract address')
  .addOptionalParam('noundersdao', 'The nounders DAO contract address')
  .addOptionalParam('vetoer', 'The vetoer address', undefined, types.string)
  .addOptionalParam('auctionTimeBuffer', 'The auction time buffer (seconds)', undefined, types.int)
  .addOptionalParam('auctionReservePrice', 'The auction reserve price (wei)', undefined, types.int)
  .addOptionalParam(
    'auctionMinIncrementBidPercentage',
    'The auction min increment bid percentage (out of 100)',
    undefined,
    types.int,
  )
  .addOptionalParam(
    'auctionBaseDuration',
    'The auction base duration (seconds)',
    undefined,
    types.int,
  )
  .addOptionalParam('timelockDelay', 'The timelock delay (seconds)', undefined, types.int)
  .addOptionalParam('votingPeriod', 'The voting period (blocks)', undefined, types.int)
  .addOptionalParam('votingDelay', 'The voting delay (blocks)', undefined, types.int)
  .addOptionalParam('proposalThreshold', 'The proposal threshold', undefined, types.int)
  .addOptionalParam(
    'minQuorumVotesBPS',
    'Min basis points input for dynamic quorum',
    undefined,
    types.int,
  ) // Default: 10%
  .addOptionalParam(
    'maxQuorumVotesBPS',
    'Max basis points input for dynamic quorum',
    undefined,
    types.int,
  ) // Default: 15%
  .addOptionalParam(
    'quorumCoefficient',
    'Dynamic quorum coefficient (float)',
    undefined,
    types.float,
  )
  .setAction(async (args, { ethers, run }) => {
    console.log(`nijinouns`)
    const deployAddress = createSigner(ethers.provider).address;
    let balance = await ethers.provider.getBalance(deployAddress);
    console.log(`Deployer address = ${deployAddress}`);
    console.log(`Deployer balance = ${ethers.utils.formatEther(balance)} ETH`);

    // Deploy the NijiNouns DAO contracts and return deployment information
    const contracts = await run('nigi-deploy', args);

    // Verify the contracts on Etherscan
    if (args.verifyEtherscan) {
      console.log('Verifying contracts via Etherscan API');
      await run('verify-etherscan', {
        contracts,
      });
    }

    balance = await ethers.provider.getBalance(deployAddress);
    console.log(`Deployer balance after deployment = ${ethers.utils.formatEther(balance)} ETH`);

    // Populate the on-chain art
    console.log('Populate descriptor');
    await run('niginouns-populate-descriptor', {
      nftDescriptor: contracts.NFTDescriptorV2.address,
      nounsDescriptor: contracts.NounsDescriptorV2.address,
    });

    // Transfer ownership of all contract except for the auction house.
    // We must maintain ownership of the auction house to kick off the first auction.
    // .

    // Optionally write the deployed addresses to the SDK and subgraph configs.
    if (args.updateConfigs) {
      console.log('Update configurations');
      await run('update-configs-daov2', {
        contracts,
      });
    }

    printContractsTable(contracts);
    console.log('Deployment Complete.');

    balance = await ethers.provider.getBalance(deployAddress);
    console.log(`Deployer balance after all = ${ethers.utils.formatEther(balance)} ETH`);
  });
