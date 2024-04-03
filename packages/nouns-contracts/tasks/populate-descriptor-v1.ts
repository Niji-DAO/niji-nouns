import { task, types } from 'hardhat/config';
import ImageData from '../files/image-data-64.json';

task('populate-descriptor-v1', 'Populates the descriptor with color palettes and Noun parts')
  .addOptionalParam(
    'nftDescriptor',
    'The `NFTDescriptor` contract address',
    '0x5FbDB2315678afecb367f032d93F642f64180aa3',
    types.string,
  )
  .addOptionalParam(
    'nounsDescriptor',
    'The `NounsDescriptor` contract address',
    '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512',
    types.string,
  )
  .setAction(async ({ nftDescriptor, nounsDescriptor }, { ethers }) => {
    const descriptorFactory = await ethers.getContractFactory('NounsDescriptor', {
      libraries: {
        NFTDescriptor: nftDescriptor,
      },
    });
    const descriptorContract = descriptorFactory.attach(nounsDescriptor);

    const { bgcolors, palette, images } = ImageData;
    const {
      backgroundDecorations,
      backs,
      specials,
      clothes,
      backDecorations,
      chokers,
      ears,
      hairs,
      headphones,
      hats,
      leftHands,
    } = images;

    // Chunk head and skills population due to high gas usage
    await descriptorContract.addManyBackgrounds(bgcolors);
    await descriptorContract.addManyColorsToPalette(0, palette);
    await descriptorContract.addManySpecials(specials.map(({ data }: any) => data));
    await descriptorContract.addManyChokers(chokers.map(({ data }: any) => data));
    await descriptorContract.addManyHeadphones(headphones.map(({ data }: any) => data));
    await descriptorContract.addManyLeftHands(leftHands.map(({ data }: any) => data));
    await descriptorContract.addManyHats(hats.map(({ data }: any) => data));
    await descriptorContract.addManyClothes(clothes.map(({ data }: any) => data));
    await descriptorContract.addManyEars(ears.map(({ data }: any) => data));
    await descriptorContract.addManyBacks(backs.map(({ data }: any) => data));
    await descriptorContract.addManyBackDecorations(backDecorations.map(({ data }: any) => data));
    await descriptorContract.addManyBackgroundDecorations(
      backgroundDecorations.map(({ data }: any) => data),
    );
    await descriptorContract.addManyHairs(hairs.map(({ data }: any) => data));

    console.log('Descriptor populated with palettes and parts.');
  });
