import chai from 'chai';
import { solidity } from 'ethereum-waffle';
import { appendFileSync } from 'fs';
import { ethers } from 'hardhat';
import ImageData from '../files/image-data-32.json';
// import ImageData from '../files/image-data-48.json';
// import ImageData from '../files/image-data-64.json';
// import ImageData from '../files/image-s3.json';
import { NounsDescriptorV2 } from '../typechain';
import { LongestPart } from './types';
import { deployNounsDescriptorV2, populateDescriptorV2 } from './utils';

chai.use(solidity);
const { expect } = chai;

describe('NounsDescriptorV2', () => {
  let nounsDescriptor: NounsDescriptorV2;
  let snapshotId: number;

  const part: LongestPart = {
    length: 0,
    index: 0,
  };
  const longest: Record<string, LongestPart> = {
    backgroundDecorations: part,
    backs: part,
    specials: part,
    clothes: part,
    backDecorations: part,
    chokers: part,
    ears: part,
    hairs: part,
    headphones: part,
    hats: part,
    leftHands: part,
  };

  before(async () => {
    nounsDescriptor = await deployNounsDescriptorV2();
    console.log(`start nounsDescriptor: ${nounsDescriptor}`);

    for (const [l, layer] of Object.entries(ImageData.images)) {
      for (const [i, item] of layer.entries()) {
        if (item.data.length > longest[l].length) {
          longest[l] = {
            length: item.data.length,
            index: i,
          };
        }
      }
    }

    await populateDescriptorV2(nounsDescriptor);
  });

  beforeEach(async () => {
    snapshotId = await ethers.provider.send('evm_snapshot', []);
  });

  afterEach(async () => {
    await ethers.provider.send('evm_revert', [snapshotId]);
  });

  // Unskip this test to validate the encoding of all parts. It ensures that no parts revert when building the token URI.
  // This test also outputs a parts.html file, which can be visually inspected.
  // Note that this test takes a long time to run. You must increase the mocha timeout to a large number.
  it('should generate valid token uri metadata for all supported parts when data uris are enabled', async () => {
    console.log('Running... this may take a little while...');

    const { bgcolors, images } = ImageData;
    console.log('import ImageData ok!');
    console.log(`bgcolors: ${bgcolors}`);
    console.log(`bgcolors: ${bgcolors.length}`);
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
    console.log('import images ok!');
    const max = Math.max(
      backgroundDecorations.length,
      backs.length,
      specials.length,
      clothes.length,
      backDecorations.length,
      chokers.length,
      ears.length,
      hairs.length,
      headphones.length,
      hats.length,
      leftHands.length,
    );
    console.log('const max ok!');
    for (let i = 0; i < max; i++) {
      console.log(`background: ${Math.min(i, bgcolors.length - 1)}`);
      console.log(`special: ${Math.min(i, specials.length - 1)}`);
      console.log(`choker: ${Math.min(i, chokers.length - 1)}`);
      console.log(`headphone: ${Math.min(i, headphones.length - 1)}`);
      console.log(`leftHand: ${Math.min(i, leftHands.length - 1)}`);
      console.log(`hat: ${Math.min(i, hats.length - 1)}`);
      console.log(`clothe: ${Math.min(i, clothes.length - 1)}`);
      console.log(`ear: ${Math.min(i, ears.length - 1)}`);
      console.log(`back: ${Math.min(i, backs.length - 1)}`);
      console.log(`backDecoration: ${Math.min(i, backDecorations.length - 1)}`);
      console.log(`backgroundDecoration: ${Math.min(i, backgroundDecorations.length - 1)}`);
      console.log(`hair: ${Math.min(i, hairs.length - 1)}`);

      const seeds = {
        background: Math.floor(Math.random() * bgcolors.length),
        backgroundDecoration: Math.floor(Math.random() * backgroundDecorations.length),
        special: Math.floor(Math.random() * specials.length),
        leftHand: Math.floor(Math.random() * leftHands.length),
        back: Math.floor(Math.random() * backs.length),
        ear: Math.floor(Math.random() * ears.length),
        choker: Math.floor(Math.random() * chokers.length),
        clothe: Math.floor(Math.random() * clothes.length),
        hair: Math.floor(Math.random() * hats.length),
        headphone: Math.floor(Math.random() * headphones.length),
        hat: Math.floor(Math.random() * hats.length),
        backDecoration: Math.floor(Math.random() * backDecorations.length),
      };
      console.log(`seeds: ${JSON.stringify(seeds)}`);
      const tokenUri = await nounsDescriptor.tokenURI(
        i,
        seeds,
        { gasLimit: 200_000_000_000 },
      );
      console.log(`${i} tokenUri ok!`);
      const { name, description, image } = JSON.parse(
        Buffer.from(tokenUri.replace('data:application/json;base64,', ''), 'base64').toString(
          'ascii',
        ),
      );
      console.log(`image: ${image}`);
      expect(name).to.equal(`NijiNoun ${i}`);
      expect(description).to.equal(`NijiNoun ${i} is a member of the Niji DAO`);
      expect(image).to.not.be.undefined;

      appendFileSync(
        'parts.html',
        Buffer.from(image.split(';base64,').pop(), 'base64').toString('ascii'),
      );

      if (i && i % Math.round(max / 10) === 0) {
        console.log(`${Math.round((i / max) * 100)}% complete`);
      }
    }
  }).timeout(6 * 60 * 60 * 1_000_000);
});
