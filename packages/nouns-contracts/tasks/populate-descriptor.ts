import { task, types } from 'hardhat/config';
// import ImageData from '../files/image-data-v2.json';
// import ImageData from '../files/image-data-64.json';
// import ImageData from '../files/image-data-64.json';
import ImageData from '../files/image-s3.json';
import { dataToDescriptorInput } from './utils';
import { NounsDescriptorV2, NounsDescriptorV2__factory } from '../typechain';

task('populate-descriptor', 'Populates the descriptor with color palettes and Noun parts')
  .addOptionalParam(
    'nftDescriptor',
    'The `NFTDescriptorV2` contract address',
    '0x5FbDB2315678afecb367f032d93F642f64180aa3',
    types.string,
  )
  .addOptionalParam(
    'nounsDescriptor',
    'The `NounsDescriptorV2` contract address',
    '0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512',
    types.string,
  )
  .setAction(async ({ nftDescriptor, nounsDescriptor }, { ethers, network }) => {
    // const options = { gasLimit: network.name === 'hardhat' ? 30000000 : undefined };
    const options = { gasLimit: network.name === 'hardhat' ? undefined : undefined };

    const descriptorFactory: NounsDescriptorV2__factory = await ethers.getContractFactory(
      'NounsDescriptorV2',
      {
        libraries: {
          NFTDescriptorV2: nftDescriptor,
        },
      },
    );
    const descriptorContract: NounsDescriptorV2 = descriptorFactory.attach(nounsDescriptor);

    const { bgcolors, palette, images } = ImageData;
    const {
      backgroundDecorations,
      specials,
      leftHands,
      backs,
      ears,
      chokers,
      clothes,
      hairs,
      headphones,
      hats,
      backDecorations,
    } = images;

    console.log(`bgcolors: ${bgcolors}`);
    console.log(`palette: ${palette}`);
    console.log(`images: ${JSON.stringify(images)}`);

    const backgroundDecorationData: string[] = backgroundDecorations.map(
      backgroundDecoration => backgroundDecoration.data,
    );

    console.log(`🚀 backgroundDecorationData: ${backgroundDecorationData}`);

    const specialData: string[] = specials.map(special => special.data);

    console.log(`🚀 specialData: ${specialData}`);

    const leftHandData: string[] = leftHands.map(leftHand => leftHand.data);

    console.log(`🚀 leftHandData: ${leftHandData}`);

    const backData: string[] = backs.map(back => back.data);

    console.log(`🚀 backData: ${backData}`);

    const earData: string[] = ears.map(ear => ear.data);

    console.log(`🚀 earData: ${earData}`);

    const chokerData: string[] = chokers.map(choker => choker.data);

    console.log(`🚀 chokerData: ${chokerData}`);

    const clotheData: string[] = clothes.map(clothe => clothe.data);

    console.log(`🚀 clotheData: ${clotheData}`);

    const hairData: string[] = hairs.map(hair => hair.data);

    console.log(`🚀 hairData: ${hairData}`);

    const headphoneData: string[] = headphones.map(headphone => headphone.data);

    console.log(`🚀 headphoneData: ${headphoneData}`);

    const hatData: string[] = hats.map(hat => hat.data);

    console.log(`🚀 hatData: ${hatData}`);

    const backDecorationData: string[] = backDecorations.map(backDecoration => backDecoration.data);

    console.log(`🚀 backDecorationData: ${backDecorationData}`);

    console.log('populate descriptor v2');

    await descriptorContract.addManyBackgrounds(bgcolors);
    await descriptorContract.setPalette(0, `0x000000${palette.join('')}`);

    console.log('addSpecials');
    await descriptorContract.addSpecialIdentifiers(specialData, options);

    console.log('addChokers');
    await descriptorContract.addChokerIdentifiers(chokerData, options);

    console.log('addHeadphones');
    await descriptorContract.addHeadphoneIdentifiers(headphoneData, options);

    console.log('addLeftHands');
    await descriptorContract.addLeftHandIdentifiers(leftHandData, options);

    console.log('addHats');
    await descriptorContract.addHatIdentifiers(hatData, options);

    console.log('addClothes');
    await descriptorContract.addClotheIdentifiers(clotheData, options);

    console.log('addEars');
    await descriptorContract.addEarIdentifiers(earData, options);

    console.log('addBacks');
    await descriptorContract.addBackIdentifiers(backData, options);

    console.log('addBackDecorations');
    await descriptorContract.addBackDecorationIdentifiers(backDecorationData, options);

    console.log('addBackgroundDecorations');
    await descriptorContract.addBackgroundDecorationIdentifiers(backDecorationData, options);

    console.log('addHairs');
    await descriptorContract.addHairIdentifiers(hairData, options);

    console.log('Descriptor populated with palettes and parts.');
  });
