import chai from 'chai';
import { solidity } from 'ethereum-waffle';
import { NounsDescriptor } from '../typechain';
// import ImageData from '../files/image-data-v1.json';
import { appendFileSync } from 'fs';
import { ethers } from 'hardhat';
// import ImageData from '../files/image-data-64.json';
import ImageData from '../files/image-data-64.json';
import { LongestPart } from './types';
import { deployNounsDescriptor, populateDescriptor } from './utils';

chai.use(solidity);
const { expect } = chai;

describe('NounsDescriptor', () => {
  let nounsDescriptor: NounsDescriptor;
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
    nounsDescriptor = await deployNounsDescriptor();

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

    await populateDescriptor(nounsDescriptor);
  });

  beforeEach(async () => {
    snapshotId = await ethers.provider.send('evm_snapshot', []);
  });

  afterEach(async () => {
    await ethers.provider.send('evm_revert', [snapshotId]);
  });

  it('should generate valid token uri metadata when data uris are disabled', async () => {
    const BASE_URI = 'https://api.nouns.wtf/metadata/';

    await nounsDescriptor.setBaseURI(BASE_URI);
    await nounsDescriptor.toggleDataURIEnabled();

    const tokenUri = await nounsDescriptor.tokenURI(0, {
      background: 0,
      backgroundDecoration: longest.backgroundDecorations.index,
      back: longest.backs.index,
      special: longest.specials.index,
      clothe: longest.clothes.index,
      backDecoration: longest.backDecorations.index,
      choker: longest.chokers.index,
      ear: longest.ears.index,
      hair: longest.hairs.index,
      headphone: longest.headphones.index,
      hat: longest.hats.index,
      leftHand: longest.leftHands.index,
    });
    expect(tokenUri).to.equal(`${BASE_URI}0`);
  });

  // Unskip this test to validate the encoding of all parts. It ensures that no parts revert when building the token URI.
  // This test also outputs a parts.html file, which can be visually inspected.
  // Note that this test takes a long time to run. You must increase the mocha timeout to a large number.
  it.skip('should generate valid token uri metadata for all supported parts when data uris are enabled', async () => {
    console.log('Running... this may take a little while...');

    const { bgcolors, images } = ImageData;
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
    for (let i = 0; i < max; i++) {
      const tokenUri = await nounsDescriptor.tokenURI(i, {
        backgroundDecoration: Math.min(i, backgroundDecorations.length - 1),
        back: Math.min(i, backs.length - 1),
        background: Math.min(i, bgcolors.length - 1),
        special: Math.min(i, specials.length - 1),
        clothe: Math.min(i, clothes.length),
        backDecoration: Math.min(i, backDecorations.length - 1),
        choker: Math.min(i, chokers.length - 1),
        ear: Math.min(i, ears.length - 1),
        hair: Math.min(i, hairs.length - 1),
        headphone: Math.min(i, headphones.length - 1),
        hat: Math.min(i, hats.length - 1),
        leftHand: Math.min(i, leftHands.length - 1),
      });
      const { name, description, image } = JSON.parse(
        Buffer.from(tokenUri.replace('data:application/json;base64,', ''), 'base64').toString(
          'ascii',
        ),
      );
      expect(name).to.equal(`Noun ${i}`);
      expect(description).to.equal(`Noun ${i} is a member of the Nouns DAO`);
      expect(image).to.not.be.undefined;

      appendFileSync(
        'parts.html',
        Buffer.from(image.split(';base64,').pop(), 'base64').toString('ascii'),
      );

      if (i && i % Math.round(max / 10) === 0) {
        console.log(`${Math.round((i / max) * 100)}% complete`);
      }
    }
  });
});
