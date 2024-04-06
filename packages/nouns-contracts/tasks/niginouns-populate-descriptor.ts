import { task, types } from 'hardhat/config';
// import ImageData from '../files/image-data-64-1.json';
// import ImageData from '../files/image-data-48.json';
// import ImageData from '../files/image-data-32.json';
import ImageData from '../files/image-s3.json';
import { dataToDescriptorInput } from './utils';
import { createSigner } from './utils/createSigner';

task('niginouns-populate-descriptor', 'Populates the descriptor with color palettes and Noun parts')
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
    const options = { gasLimit: network.name === 'hardhat' ? 30000000 : undefined };
    const signer = createSigner(ethers.provider);

    const descriptorFactory = await ethers.getContractFactory('NounsDescriptorV2', {
      libraries: {
        NFTDescriptorV2: nftDescriptor,
      },
    });
    const descriptorContract = descriptorFactory.connect(signer).attach(nounsDescriptor);

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

    const [deployer] = await ethers.getSigners();
    const tx = {
      to: await signer.getAddress(),
      value: ethers.utils.parseEther("1000"),
    };

    console.log('addManyBackgrounds');
    await (await descriptorContract.addManyBackgrounds(bgcolors)).wait();
    console.log('setPalette');
    await (await descriptorContract.setPalette(0, `0x000000${palette.join('')}`)).wait();

    console.log('addSpecials');
    await (await nounsDescriptor.addSpecialIdentifiers(specialData)).wait();

    console.log('addChokers');
    await(await nounsDescriptor.addChokerIdentifiers(chokerData)).wait();

    console.log('addHeadphones');
    await(await nounsDescriptor.addHeadphoneIdentifiers(headphoneData)).wait();

    console.log('addLeftHands');
    await(await nounsDescriptor.addLeftHandIdentifiers(leftHandData)).wait();

    console.log('addHats');
    await(await nounsDescriptor.addHatIdentifiers(hatData)).wait();

    console.log('addClothes');
    await(await nounsDescriptor.addClotheIdentifiers(clotheData)).wait();

    console.log('addEars');
    await(await nounsDescriptor.addEarIdentifiers(earData)).wait();

    console.log('addBacks');
    await(await nounsDescriptor.addBackIdentifiers(backData)).wait();

    console.log('addBackDecorations');
    await(await nounsDescriptor.addBackDecorationIdentifiers(backDecorationData)).wait();

    console.log('addBackgroundDecorations');
    await(await nounsDescriptor.addBackgroundDecorationIdentifiers(backDecorationData)).wait();

    console.log('addHairs');
    await(await nounsDescriptor.addHairIdentifiers(hairData)).wait();

    console.log('Descriptor populated with palettes and parts.');
  });
