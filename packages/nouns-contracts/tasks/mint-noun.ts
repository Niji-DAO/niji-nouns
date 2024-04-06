import { Result } from 'ethers/lib/utils';
import { task, types } from 'hardhat/config';

task('mint-noun', 'Mints a Noun')
  .addOptionalParam(
    'nounsToken',
    'The `NounsToken` contract address',
    '0x58569d9954C834a1ca94996057B1C4f1D867F2cC',
    types.string,
  )
  .setAction(async ({ nounsToken }, { ethers }) => {
    const nftFactory = await ethers.getContractFactory('NounsToken');
    const nftContract = nftFactory.attach(nounsToken);

    const receipt = await (await nftContract.mint()).wait();
    const nounCreated = receipt.events?.[1];
    const { tokenId } = nounCreated?.args as Result;

    console.log(`Noun minted with ID: ${tokenId.toString()}.`);
  });
