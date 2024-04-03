import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { ethers, network } from 'hardhat';
import {
  Inflator__factory,
  NounsArt__factory as NounsArtFactory,
  NounsDAOExecutor,
  NounsDAOLogicV1,
  NounsDAOLogicV1Harness,
  NounsDAOLogicV2,
  NounsDAOStorageV2,
  NounsDAOExecutor__factory as NounsDaoExecutorFactory,
  NounsDAOLogicV1__factory as NounsDaoLogicV1Factory,
  NounsDAOLogicV1Harness__factory as NounsDaoLogicV1HarnessFactory,
  NounsDAOLogicV2__factory as NounsDaoLogicV2Factory,
  NounsDAOProxy__factory as NounsDaoProxyFactory,
  NounsDAOProxyV2__factory as NounsDaoProxyV2Factory,
  NounsDescriptor,
  NounsDescriptor__factory as NounsDescriptorFactory,
  NounsDescriptorV2,
  NounsDescriptorV2__factory as NounsDescriptorV2Factory,
  NounsSeeder,
  NounsSeeder__factory as NounsSeederFactory,
  NounsToken,
  NounsToken__factory as NounsTokenFactory,
  SVGRenderer__factory as SVGRendererFactory,
  WETH,
  WETH__factory as WethFactory,
} from '../typechain';
// import ImageData from '../files/image-data-v1.json';
import { Block } from '@ethersproject/abstract-provider';
import { BigNumber } from 'ethers';
import { deflateRawSync } from 'zlib';
import ImageData from '../files/image-data-32.json';
// import ImageData from '../files/image-data-48.json';
// import ImageData from '../files/image-data-64.json';
import { MAX_QUORUM_VOTES_BPS, MIN_QUORUM_VOTES_BPS } from './constants';
import { DynamicQuorumParams } from './types';

export type TestSigners = {
  deployer: SignerWithAddress;
  account0: SignerWithAddress;
  account1: SignerWithAddress;
  account2: SignerWithAddress;
  account3: SignerWithAddress;
};

export const getSigners = async (): Promise<TestSigners> => {
  const [deployer, account0, account1, account2, account3] = await ethers.getSigners();
  return {
    deployer,
    account0,
    account1,
    account2,
    account3,
  };
};

export const deployNounsDescriptor = async (
  deployer?: SignerWithAddress,
): Promise<NounsDescriptor> => {
  const signer = deployer || (await getSigners()).deployer;
  const nftDescriptorLibraryFactory = await ethers.getContractFactory('NFTDescriptor', signer);
  const nftDescriptorLibrary = await nftDescriptorLibraryFactory.deploy();
  const nounsDescriptorFactory = new NounsDescriptorFactory(
    {
      'contracts/libs/NFTDescriptor.sol:NFTDescriptor': nftDescriptorLibrary.address,
    },
    signer,
  );

  return nounsDescriptorFactory.deploy();
};

export const deployNounsDescriptorV2 = async (
  deployer?: SignerWithAddress,
): Promise<NounsDescriptorV2> => {
  const signer = deployer || (await getSigners()).deployer;
  const nftDescriptorLibraryFactory = await ethers.getContractFactory('NFTDescriptorV2', signer);
  const nftDescriptorLibrary = await nftDescriptorLibraryFactory.deploy();
  const nounsDescriptorFactory = new NounsDescriptorV2Factory(
    {
      'contracts/libs/NFTDescriptorV2.sol:NFTDescriptorV2': nftDescriptorLibrary.address,
    },
    signer,
  );

  const renderer = await new SVGRendererFactory(signer).deploy();
  const descriptor = await nounsDescriptorFactory.deploy(
    ethers.constants.AddressZero,
    renderer.address,
  );

  const inflator = await new Inflator__factory(signer).deploy();

  const art = await new NounsArtFactory(signer).deploy(descriptor.address, inflator.address);
  await descriptor.setArt(art.address);

  return descriptor;
};

export const deployNounsSeeder = async (deployer?: SignerWithAddress): Promise<NounsSeeder> => {
  const factory = new NounsSeederFactory(deployer || (await getSigners()).deployer);

  return factory.deploy();
};

export const deployNounsToken = async (
  deployer?: SignerWithAddress,
  noundersDAO?: string,
  minter?: string,
  descriptor?: string,
  seeder?: string,
  proxyRegistryAddress?: string,
): Promise<NounsToken> => {
  const signer = deployer || (await getSigners()).deployer;
  const factory = new NounsTokenFactory(signer);

  return factory.deploy(
    noundersDAO || signer.address,
    minter || signer.address,
    descriptor || (await deployNounsDescriptorV2(signer)).address,
    seeder || (await deployNounsSeeder(signer)).address,
    proxyRegistryAddress || address(0),
  );
};

export const deployWeth = async (deployer?: SignerWithAddress): Promise<WETH> => {
  const factory = new WethFactory(deployer || (await getSigners()).deployer);

  return factory.deploy();
};

export const populateDescriptor = async (nounsDescriptor: NounsDescriptor): Promise<void> => {
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

  // Split up head and skill population due to high gas usage
  await Promise.all([
    nounsDescriptor.addManyBackgrounds(bgcolors),
    nounsDescriptor.addManyColorsToPalette(0, palette),
    nounsDescriptor.addManyBackgroundDecorations(backgroundDecorations.map(({ data }) => data)),
    nounsDescriptor.addManyBacks(backs.map(({ data }) => data)),
    nounsDescriptor.addManySpecials(specials.map(({ data }) => data)),
    nounsDescriptor.addManyClothes(clothes.map(({ data }) => data)),
    nounsDescriptor.addManyBackDecorations(backDecorations.map(({ data }) => data)),
    nounsDescriptor.addManyChokers(chokers.map(({ data }) => data)),
    nounsDescriptor.addManyEars(ears.map(({ data }) => data)),
    nounsDescriptor.addManyHairs(hairs.map(({ data }) => data)),
    nounsDescriptor.addManyHeadphones(headphones.map(({ data }) => data)),
    nounsDescriptor.addManyHats(hats.map(({ data }) => data)),
    nounsDescriptor.addManyLeftHands(leftHands.map(({ data }) => data)),
  ]);
};

export const populateDescriptorV2 = async (nounsDescriptor: NounsDescriptorV2): Promise<void> => {
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

  const {
    encodedCompressed: specialsCompressed,
    originalLength: specialsLength,
    itemCount: specialsCount,
  } = dataToDescriptorInput(specials.map(({ data }) => data));

  console.log(`populateDescriptorV2 specials OK!`);

  const {
    encodedCompressed: chokersCompressed,
    originalLength: chokersLength,
    itemCount: chokersCount,
  } = dataToDescriptorInput(chokers.map(({ data }) => data));

  console.log(`populateDescriptorV2 chokers OK!`);

  const {
    encodedCompressed: headphonesCompressed,
    originalLength: headphonesLength,
    itemCount: headphonesCount,
  } = dataToDescriptorInput(headphones.map(({ data }) => data));

  console.log(`populateDescriptorV2 headphones OK!`);

  const {
    encodedCompressed: leftHandsCompressed,
    originalLength: leftHandsLength,
    itemCount: leftHandsCount,
  } = dataToDescriptorInput(leftHands.map(({ data }) => data));

  console.log(`populateDescriptorV2 leftHands OK!`);

  const {
    encodedCompressed: hatsCompressed,
    originalLength: hatsLength,
    itemCount: hatsCount,
  } = dataToDescriptorInput(hats.map(({ data }) => data));

  console.log(`populateDescriptorV2 hats OK!`);

  const {
    encodedCompressed: clothesCompressed,
    originalLength: clothesLength,
    itemCount: clothesCount,
  } = dataToDescriptorInput(clothes.map(({ data }) => data));

  console.log(`populateDescriptorV2 clothes OK!`);

  const {
    encodedCompressed: earsCompressed,
    originalLength: earsLength,
    itemCount: earsCount,
  } = dataToDescriptorInput(ears.map(({ data }) => data));

  console.log(`populateDescriptorV2 ears OK!`);

  const {
    encodedCompressed: backsCompressed,
    originalLength: backsLength,
    itemCount: backsCount,
  } = dataToDescriptorInput(backs.map(({ data }) => data));

  console.log(`populateDescriptorV2 backs OK!`);

  const {
    encodedCompressed: backDecorationsCompressed,
    originalLength: backDecorationsLength,
    itemCount: backDecorationsCount,
  } = dataToDescriptorInput(backDecorations.map(({ data }) => data));

  console.log(`populateDescriptorV2 backDecorations OK!`);

  const {
    encodedCompressed: backgroundDecorationsCompressed,
    originalLength: backgroundDecorationsLength,
    itemCount: backgroundDecorationsCount,
  } = dataToDescriptorInput(backgroundDecorations.map(({ data }: any) => data));

  console.log(`populateDescriptorV2 backgroundDecorations OK!`);

  const {
    encodedCompressed: hairsCompressed,
    originalLength: hairsLength,
    itemCount: hairsCount,
  } = dataToDescriptorInput(hairs.map(({ data }) => data));

  console.log(`populateDescriptorV2 hairs OK!`);

  await nounsDescriptor.addManyBackgrounds(bgcolors);
  await nounsDescriptor.setPalette(0, `0x000000${palette.join('')}`);
  await nounsDescriptor.addSpecials(specialsCompressed, specialsLength, specialsCount);
  await nounsDescriptor.addChokers(chokersCompressed, chokersLength, chokersCount);
  await nounsDescriptor.addHeadphones(headphonesCompressed, headphonesLength, headphonesCount);
  await nounsDescriptor.addLeftHands(leftHandsCompressed, leftHandsLength, leftHandsCount);
  await nounsDescriptor.addHats(hatsCompressed, hatsLength, hatsCount);
  await nounsDescriptor.addClothes(clothesCompressed, clothesLength, clothesCount);
  await nounsDescriptor.addEars(earsCompressed, earsLength, earsCount);
  await nounsDescriptor.addBacks(backsCompressed, backsLength, backsCount);
  await nounsDescriptor.addBackDecorations(
    backDecorationsCompressed,
    backDecorationsLength,
    backDecorationsCount,
  );
  await nounsDescriptor.addBackgroundDecorations(
    backgroundDecorationsCompressed,
    backgroundDecorationsLength,
    backgroundDecorationsCount,
  );
  await nounsDescriptor.addHairs(hairsCompressed, hairsLength, hairsCount);
};

export const deployGovAndToken = async (
  deployer: SignerWithAddress,
  timelockDelay: number,
  proposalThreshold: number,
  quorumVotesBPS: number,
  vetoer?: string,
): Promise<{ token: NounsToken; gov: NounsDAOLogicV1; timelock: NounsDAOExecutor }> => {
  // nonce 0: Deploy NounsDAOExecutor
  // nonce 1: Deploy NounsDAOLogicV1
  // nonce 2: Deploy nftDescriptorLibraryFactory
  // nonce 3: Deploy SVGRenderer
  // nonce 4: Deploy NounsDescriptor
  // nonce 5: Deploy Inflator
  // nonce 6: Deploy NounsArt
  // nonce 7: NounsDescriptor.setArt
  // nonce 8: Deploy NounsSeeder
  // nonce 9: Deploy NounsToken
  // nonce 10: Deploy NounsDAOProxy
  // nonce 11+: populate Descriptor

  const govDelegatorAddress = ethers.utils.getContractAddress({
    from: deployer.address,
    nonce: (await deployer.getTransactionCount()) + 10,
  });

  // Deploy NounsDAOExecutor with pre-computed Delegator address
  const timelock = await new NounsDaoExecutorFactory(deployer).deploy(
    govDelegatorAddress,
    timelockDelay,
  );

  // Deploy Delegate
  const { address: govDelegateAddress } = await new NounsDaoLogicV1Factory(deployer).deploy();
  // Deploy Nouns token
  const token = await deployNounsToken(deployer);

  // Deploy Delegator
  await new NounsDaoProxyFactory(deployer).deploy(
    timelock.address,
    token.address,
    vetoer || address(0),
    timelock.address,
    govDelegateAddress,
    5760,
    1,
    proposalThreshold,
    quorumVotesBPS,
  );

  // Cast Delegator as Delegate
  const gov = NounsDaoLogicV1Factory.connect(govDelegatorAddress, deployer);

  await populateDescriptorV2(NounsDescriptorV2Factory.connect(await token.descriptor(), deployer));

  return { token, gov, timelock };
};

export const deployGovV2AndToken = async (
  deployer: SignerWithAddress,
  timelockDelay: number,
  proposalThresholdBPS: number,
  quorumParams: NounsDAOStorageV2.DynamicQuorumParamsStruct,
  vetoer?: string,
): Promise<{ token: NounsToken; gov: NounsDAOLogicV2; timelock: NounsDAOExecutor }> => {
  const govDelegatorAddress = ethers.utils.getContractAddress({
    from: deployer.address,
    nonce: (await deployer.getTransactionCount()) + 10,
  });

  // Deploy NounsDAOExecutor with pre-computed Delegator address
  const timelock = await new NounsDaoExecutorFactory(deployer).deploy(
    govDelegatorAddress,
    timelockDelay,
  );

  // Deploy Delegate
  const { address: govDelegateAddress } = await new NounsDaoLogicV2Factory(deployer).deploy();
  // Deploy Nouns token
  const token = await deployNounsToken(deployer);

  // Deploy Delegator
  await new NounsDaoProxyV2Factory(deployer).deploy(
    timelock.address,
    token.address,
    vetoer || address(0),
    timelock.address,
    govDelegateAddress,
    5760,
    1,
    proposalThresholdBPS,
    quorumParams,
  );

  // Cast Delegator as Delegate
  const gov = NounsDaoLogicV2Factory.connect(govDelegatorAddress, deployer);

  await populateDescriptorV2(NounsDescriptorV2Factory.connect(await token.descriptor(), deployer));

  return { token, gov, timelock };
};

/**
 * Return a function used to mint `amount` Nouns on the provided `token`
 * @param token The Nouns ERC721 token
 * @param amount The number of Nouns to mint
 */
export const MintNouns = (
  token: NounsToken,
  burnNoundersTokens = true,
): ((amount: number) => Promise<void>) => {
  return async (amount: number): Promise<void> => {
    for (let i = 0; i < amount; i++) {
      await token.mint();
    }
    if (!burnNoundersTokens) return;

    await setTotalSupply(token, amount);
  };
};

/**
 * Mints or burns tokens to target a total supply. Due to Nounders' rewards tokens may be burned and tokenIds will not be sequential
 */
export const setTotalSupply = async (token: NounsToken, newTotalSupply: number): Promise<void> => {
  const totalSupply = (await token.totalSupply()).toNumber();

  if (totalSupply < newTotalSupply) {
    for (let i = 0; i < newTotalSupply - totalSupply; i++) {
      await token.mint();
    }
    // If Nounder's reward tokens were minted totalSupply will be more than expected, so run setTotalSupply again to burn extra tokens
    await setTotalSupply(token, newTotalSupply);
  }

  if (totalSupply > newTotalSupply) {
    for (let i = newTotalSupply; i < totalSupply; i++) {
      await token.burn(i);
    }
  }
};

// The following adapted from `https://github.com/compound-finance/compound-protocol/blob/master/tests/Utils/Ethereum.js`

const rpc = <T = unknown>({
  method,
  params,
}: {
  method: string;
  params?: unknown[];
}): Promise<T> => {
  return network.provider.send(method, params);
};

export const encodeParameters = (types: string[], values: unknown[]): string => {
  const abi = new ethers.utils.AbiCoder();
  return abi.encode(types, values);
};

export const blockByNumber = async (n: number | string): Promise<Block> => {
  return rpc({ method: 'eth_getBlockByNumber', params: [n, false] });
};

export const increaseTime = async (seconds: number): Promise<unknown> => {
  await rpc({ method: 'evm_increaseTime', params: [seconds] });
  return rpc({ method: 'evm_mine' });
};

export const freezeTime = async (seconds: number): Promise<unknown> => {
  await rpc({ method: 'evm_increaseTime', params: [-1 * seconds] });
  return rpc({ method: 'evm_mine' });
};

export const advanceBlocks = async (blocks: number): Promise<void> => {
  for (let i = 0; i < blocks; i++) {
    await mineBlock();
  }
};

export const blockNumber = async (parse = true): Promise<number> => {
  const result = await rpc<number>({ method: 'eth_blockNumber' });
  return parse ? parseInt(result.toString()) : result;
};

export const blockTimestamp = async (
  n: number | string,
  parse = true,
): Promise<number | string> => {
  const block = await blockByNumber(n);
  return parse ? parseInt(block.timestamp.toString()) : block.timestamp;
};

export const setNextBlockBaseFee = async (value: BigNumber): Promise<void> => {
  await network.provider.send('hardhat_setNextBlockBaseFeePerGas', [value.toHexString()]);
};

export const setNextBlockTimestamp = async (n: number, mine = true): Promise<void> => {
  await rpc({ method: 'evm_setNextBlockTimestamp', params: [n] });
  if (mine) await mineBlock();
};

export const minerStop = async (): Promise<void> => {
  await network.provider.send('evm_setAutomine', [false]);
  await network.provider.send('evm_setIntervalMining', [0]);
};

export const minerStart = async (): Promise<void> => {
  await network.provider.send('evm_setAutomine', [true]);
};

export const mineBlock = async (): Promise<void> => {
  await network.provider.send('evm_mine');
};

export const chainId = async (): Promise<number> => {
  return parseInt(await network.provider.send('eth_chainId'), 16);
};

export const address = (n: number): string => {
  return `0x${n.toString(16).padStart(40, '0')}`;
};

export const propStateToString = (stateInt: number): string => {
  const states: string[] = [
    'Pending',
    'Active',
    'Canceled',
    'Defeated',
    'Succeeded',
    'Queued',
    'Expired',
    'Executed',
    'Vetoed',
  ];
  return states[stateInt];
};

export const deployGovernorV1 = async (
  deployer: SignerWithAddress,
  tokenAddress: string,
  quorumVotesBPs: number = MIN_QUORUM_VOTES_BPS,
): Promise<NounsDAOLogicV1Harness> => {
  const { address: govDelegateAddress } = await new NounsDaoLogicV1HarnessFactory(
    deployer,
  ).deploy();
  const params: Parameters<NounsDaoProxyFactory['deploy']> = [
    address(0),
    tokenAddress,
    deployer.address,
    deployer.address,
    govDelegateAddress,
    1728,
    1,
    1,
    quorumVotesBPs,
  ];

  const { address: _govDelegatorAddress } = await (
    await ethers.getContractFactory('NounsDAOProxy', deployer)
  ).deploy(...params);

  return NounsDaoLogicV1HarnessFactory.connect(_govDelegatorAddress, deployer);
};

export const deployGovernorV2WithV2Proxy = async (
  deployer: SignerWithAddress,
  tokenAddress: string,
  timelockAddress?: string,
  vetoerAddress?: string,
  votingPeriod?: number,
  votingDelay?: number,
  proposalThresholdBPs?: number,
  dynamicQuorumParams?: DynamicQuorumParams,
): Promise<NounsDAOLogicV2> => {
  const v2LogicContract = await new NounsDaoLogicV2Factory(deployer).deploy();

  const proxy = await new NounsDaoProxyV2Factory(deployer).deploy(
    timelockAddress || deployer.address,
    tokenAddress,
    vetoerAddress || deployer.address,
    deployer.address,
    v2LogicContract.address,
    votingPeriod || 5760,
    votingDelay || 1,
    proposalThresholdBPs || 1,
    dynamicQuorumParams || {
      minQuorumVotesBPS: MIN_QUORUM_VOTES_BPS,
      maxQuorumVotesBPS: MAX_QUORUM_VOTES_BPS,
      quorumCoefficient: 0,
    },
  );

  return NounsDaoLogicV2Factory.connect(proxy.address, deployer);
};

export const deployGovernorV2 = async (
  deployer: SignerWithAddress,
  proxyAddress: string,
): Promise<NounsDAOLogicV2> => {
  const v2LogicContract = await new NounsDaoLogicV2Factory(deployer).deploy();
  const proxy = NounsDaoProxyFactory.connect(proxyAddress, deployer);
  await proxy._setImplementation(v2LogicContract.address);

  const govV2 = NounsDaoLogicV2Factory.connect(proxyAddress, deployer);
  return govV2;
};

export const deployGovernorV2AndSetQuorumParams = async (
  deployer: SignerWithAddress,
  proxyAddress: string,
): Promise<NounsDAOLogicV2> => {
  const govV2 = await deployGovernorV2(deployer, proxyAddress);
  await govV2._setDynamicQuorumParams(MIN_QUORUM_VOTES_BPS, MAX_QUORUM_VOTES_BPS, 0);

  return govV2;
};

export const propose = async (
  gov: NounsDAOLogicV1 | NounsDAOLogicV2,
  proposer: SignerWithAddress,
  stubPropUserAddress: string = address(0),
) => {
  const targets = [stubPropUserAddress];
  const values = ['0'];
  const signatures = ['getBalanceOf(address)'];
  const callDatas = [encodeParameters(['address'], [stubPropUserAddress])];

  await gov.connect(proposer).propose(targets, values, signatures, callDatas, 'do nothing');
  return await gov.latestProposalIds(proposer.address);
};

function dataToDescriptorInput(data: string[]): {
  encodedCompressed: string;
  originalLength: number;
  itemCount: number;
} {
  const abiEncoded = ethers.utils.defaultAbiCoder.encode(['bytes[]'], [data]);
  const encodedCompressed = `0x${deflateRawSync(
    Buffer.from(abiEncoded.substring(2), 'hex'),
  ).toString('hex')}`;

  const originalLength = abiEncoded.substring(2).length / 2;
  const itemCount = data.length;

  return {
    encodedCompressed,
    originalLength,
    itemCount,
  };
}
