import { task, types } from 'hardhat/config';
import ImageData from '../files/image-data-64.json';
import { dataToDescriptorInput } from './utils';
import { createSigner } from './utils/createSigner';

task('nijinouns-populate-descriptor', 'Populates the descriptor with color palettes and Noun parts')
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

    const specialsPage = dataToDescriptorInput(specials.map(({ data }) => data));
    console.log('ok specials');

    const chokersPage = dataToDescriptorInput(chokers.map(({ data }) => data));
    console.log('ok chokers');

    const headphonesPage = dataToDescriptorInput(headphones.map(({ data }) => data));
    console.log('ok headphones');

    const leftHandsPage = dataToDescriptorInput(leftHands.map(({ data }) => data));
    console.log('ok leftHands');

    const hatsPage = dataToDescriptorInput(hats.map(({ data }) => data));
    console.log('ok hats');

    const clothesPage = dataToDescriptorInput(clothes.map(({ data }) => data));
    console.log('ok clothes');

    const earsPage = dataToDescriptorInput(ears.map(({ data }) => data));
    console.log('ok ears');

    const backsPage = dataToDescriptorInput(backs.map(({ data }) => data));
    console.log('ok backs');

    const backDecorationsPage = dataToDescriptorInput(backDecorations.map(({ data }) => data));
    console.log('ok backDecorations');

    const backgroundDecorationsPage = dataToDescriptorInput(
      backgroundDecorations.map(({ data }) => data),
    );
    console.log('ok backgroundDecorations');

    const hairsPage = dataToDescriptorInput(hairs.map(({ data }) => data));
    console.log('ok hairs');

    console.log('populate descriptor v2');
    console.log('addManyBackgrounds');
    await (await descriptorContract.addManyBackgrounds(bgcolors)).wait();
    console.log('setPalette');
    await (await descriptorContract.setPalette(0, `0x000000${palette.join('')}`)).wait();

    console.log('addSpecials');
    await (
      await descriptorContract.addSpecials(
        specialsPage.encodedCompressed,
        specialsPage.originalLength,
        specialsPage.itemCount,
        options,
      )
    ).wait();

    console.log('addChokers');
    await (
      await descriptorContract.addChokers(
        chokersPage.encodedCompressed,
        chokersPage.originalLength,
        chokersPage.itemCount,
        options,
      )
    ).wait();

    console.log('addHeadphones');
    await (
      await descriptorContract.addHeadphones(
        headphonesPage.encodedCompressed,
        headphonesPage.originalLength,
        headphonesPage.itemCount,
        options,
      )
    ).wait();

    console.log('addLeftHands');
    await (
      await descriptorContract.addLeftHands(
        leftHandsPage.encodedCompressed,
        leftHandsPage.originalLength,
        leftHandsPage.itemCount,
        options,
      )
    ).wait();

    console.log('addHats');
    await (
      await descriptorContract.addHats(
        hatsPage.encodedCompressed,
        hatsPage.originalLength,
        hatsPage.itemCount,
        options,
      )
    ).wait();

    console.log('addClothes');
    await (
      await descriptorContract.addClothes(
        clothesPage.encodedCompressed,
        clothesPage.originalLength,
        clothesPage.itemCount,
        options,
      )
    ).wait();

    console.log('addEars');
    await (
      await descriptorContract.addEars(
        earsPage.encodedCompressed,
        earsPage.originalLength,
        earsPage.itemCount,
        options,
      )
    ).wait();

    console.log('addBacks');
    await (
      await descriptorContract.addBacks(
        backsPage.encodedCompressed,
        backsPage.originalLength,
        backsPage.itemCount,
        options,
      )
    ).wait();

    console.log('addBackDecorations');
    await (
      await descriptorContract.addBackDecorations(
        backDecorationsPage.encodedCompressed,
        backDecorationsPage.originalLength,
        backDecorationsPage.itemCount,
        options,
      )
    ).wait();

    console.log('addBackgroundDecorations');
    await (
      await descriptorContract.addBackgroundDecorations(
        backgroundDecorationsPage.encodedCompressed,
        backgroundDecorationsPage.originalLength,
        backgroundDecorationsPage.itemCount,
        options,
      )
    ).wait();

    console.log('addHairs');
    await (
      await descriptorContract.addHairs(
        hairsPage.encodedCompressed,
        hairsPage.originalLength,
        hairsPage.itemCount,
        options,
      )
    ).wait();

    console.log('Descriptor populated with palettes and parts.');
  });
