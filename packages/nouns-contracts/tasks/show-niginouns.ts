import { task, types } from 'hardhat/config';
import { createSigner } from './utils/createSigner';

task('show-nigi', 'Show a Noun')
  .addOptionalParam(
    'nounsToken',
    'The `NounsToken` contract address',
    '0x5A9979C444ce7b331CbdE767e40aA99822CAe6f8',
    types.string,
  )
  .addOptionalParam(
    'nftDescriptor',
    'The `NFTDescriptorV2` contract address',
    '0x496C7Afd80b5a78F8320bcD310dc889a281EBb35',
    types.string,
  )
  .addOptionalParam(
    'nounsDescriptor',
    'The `NounsDescriptorV2` contract address',
    '0x05D52a46Be83b0A8D2ef6a7697458E443Ae5346e',
    types.string,
  )
  .addOptionalParam('tokenId', '`NounsToken` id', 0, types.int)
  .setAction(async ({ nounsToken, nftDescriptor, nounsDescriptor, tokenId }, { ethers }) => {
    console.log('nounsToken', nounsToken);
    console.log('nftDescriptor', nftDescriptor);
    console.log('nounsDescriptor', nounsDescriptor);
    console.log('tokenId', tokenId);

    const signer = createSigner(ethers.provider);
    const nftFactory = await ethers.getContractFactory('NounsToken');
    const nftContract = nftFactory.connect(signer).attach(nounsToken);

    console.log('minter', await nftContract.minter());

    const owner = await nftContract.ownerOf(tokenId);
    console.log('owner', owner);

    const seeds = await nftContract.seeds(tokenId);
    console.log('seeds', seeds);

    const descriptorFactory = await ethers.getContractFactory('NounsDescriptorV2', {
      libraries: {
        NFTDescriptorV2: nftDescriptor,
      },
    });
    const descriptorContract = descriptorFactory.connect(signer).attach(nounsDescriptor);

    const art = await descriptorContract.art();
    console.log('art', art);

    const extra = { gasLimit: 2_000_000_000_000 };
    // const background = await descriptorContract.backgrounds(seeds.background);
    // console.log('background', background);
    // const special = await descriptorContract.specials(seeds.special, extra);
    // console.log('special', special);
    // const choker = await descriptorContract.chokers(seeds.choker, extra);
    // console.log('choker', choker);
    // const headphone = await descriptorContract.headphones(seeds.headphone, extra);
    // console.log('headphones', headphone);
    // const leftHand = await descriptorContract.leftHands(seeds.leftHand, extra);
    // console.log('leftHand', leftHand);
    // const hat = await descriptorContract.hats(seeds.hat, extra);
    // console.log('hat', hat);
    // const clothe = await descriptorContract.clothes(seeds.clothe, extra);
    // console.log('clothe', clothe);
    // const ear = await descriptorContract.ears(seeds.ear, extra);
    // console.log('ear', ear);
    // const back = await descriptorContract.backs(seeds.back, extra);
    // console.log('back', back);
    // const backDecoration = await descriptorContract.backDecorations(seeds.backDecoration, extra);
    // console.log('backDecoration', backDecoration);
    // const backgroundDecoration = await descriptorContract.backgroundDecorations(
    //   seeds.backgroundDecoration,
    //   extra,
    // );
    // console.log('backgroundDecoration', backgroundDecoration);
    // const hair = await descriptorContract.hairs(seeds.hair, extra);
    // console.log('hair', hair);

    const svg = await descriptorContract.generateSVGImage(seeds, extra);
    console.log('svg', `data:image/svg+xml;base64,${svg}`);
    // https://base64.guru/converter/decode/image/svg

    const tokenURI = await nftContract.tokenURI(tokenId, extra);
    console.log('tokenURI', tokenURI);
  });
