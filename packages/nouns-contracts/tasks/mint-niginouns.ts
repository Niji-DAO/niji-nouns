import { Result } from 'ethers/lib/utils';
import { task, types } from 'hardhat/config';
import { createSigner } from './utils/createSigner';

task('mint-nigi-noun', 'Mints a Noun')
  .addOptionalParam(
    'nounsToken',
    'The `NounsToken` contract address',
    '0x5A9979C444ce7b331CbdE767e40aA99822CAe6f8',
    types.string,
  )
  .setAction(async ({ nounsToken }, { ethers }) => {
    const nftFactory = await ethers.getContractFactory('NounsToken');
    const nftContract = nftFactory.attach(nounsToken);

    const deployer = createSigner(ethers.provider);

    const tx = await nftContract.connect(deployer).setMinter(deployer.address);

    await tx.wait();

    console.log('change minter');

    const gasPrice = await ethers.provider.getGasPrice();

    const estimateGas = await nftContract.connect(deployer).estimateGas.mint();

    const gasLimit = estimateGas.mul(120).div(100);

    const receipt = await (
      await nftContract.connect(deployer).mint({
        gasLimit,
        gasPrice,
      })
    ).wait();
    console.log(`receipt: ${JSON.stringify(receipt)}`);
    const nounCreated = receipt.events?.[1];
    console.log(`nounCreated: ${nounCreated}`);
    const { tokenId } = nounCreated?.args as Result;

    console.log(`Noun minted with ID: ${tokenId.toString()}.`);
  });
