/* eslint-disable @typescript-eslint/no-non-null-assertion */
import { HardhatUserConfig } from 'hardhat/config';
import { NetworkUserConfig } from 'hardhat/types';
import dotenv from 'dotenv';
import '@nomiclabs/hardhat-waffle';
// import '@nomiclabs/hardhat-etherscan';
import 'solidity-coverage';
import '@typechain/hardhat';
import 'hardhat-abi-exporter';
import '@openzeppelin/hardhat-upgrades';
import 'hardhat-gas-reporter';
import '@nomicfoundation/hardhat-verify';
import './tasks';
import '@nomicfoundation/hardhat-foundry';

dotenv.config();

const userConfig: NetworkUserConfig = {};

if (process.env.MNEMONIC) {
  userConfig['accounts'] = { mnemonic: process.env.MNEMONIC };
} else if (process.env.WALLET_PRIVATE_KEY) {
  userConfig['accounts'] = [process.env.WALLET_PRIVATE_KEY];
} else if (process.env.ADDRESS_FROM) {
  userConfig['from'] = process.env.ADDRESS_FROM;
}

const config: HardhatUserConfig = {
  solidity: {
    version: '0.8.17',
    settings: {
      viaIR: true,
      optimizer: {
        enabled: true,
        runs: 200,
      },
    },
  },
  networks: {
    mainnet: {
      url: `https://mainnet.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
      ...userConfig,
    },
    rinkeby: {
      url: `https://rinkeby.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
      accounts: process.env.MNEMONIC
        ? { mnemonic: process.env.MNEMONIC }
        : [process.env.WALLET_PRIVATE_KEY!].filter(Boolean),
    },
    goerli: {
      url: `https://goerli.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
      ...userConfig,
    },
    sepolia: {
      url: `https://sepolia.infura.io/v3/${process.env.INFURA_PROJECT_ID}`,
      ...userConfig,
    },
    z_katana: {
      url: 'https://rpc.startale.com/zkatana',
      // url: 'https://astar-zkatana-rpc.dwellir.com',
      ...userConfig,
    },
    z_kyoto: {
      url: 'https://rpc.startale.com/zkyoto',
      ...userConfig,
    },
    arbitrum_spolia: {
      url: 'https://public.stackup.sh/api/v1/node/arbitrum-sepolia',
      ...userConfig,
    },
    optimism_spolia: {
      url: 'https://sepolia.optimism.io',
      ...userConfig,
    },
    base_spolia: {
      url: 'https://sepolia.base.org',
      ...userConfig,
    },
    polygon_zkevm_testnet: {
      url: 'https://rpc.public.zkevm-test.net',
      ...userConfig,
    },
    hardhat: {
      initialBaseFeePerGas: 0,
    },
  },
  etherscan: {
    apiKey: {
      mainnet: process.env.ETHERSCAN_API_KEY!,
      arbitrumSepolia: 'HFHB23H148GWEGRHDVV366R4FZ3CN2SK15',
      baseSepolia: '5a112fff-727a-4f16-b4ff-24b4c51f832a',
    },
    customChains: [
      {
        network: 'z_katana',
        chainId: 1261120,
        urls: {
          apiURL: 'https://zkatana.explorer.startale.com/api',
          browserURL: 'https://zkatana.explorer.startale.com',
        },
      },
      {
        network: 'baseSepolia',
        chainId: 84532,
        urls: {
          apiURL: 'https://base-sepolia.blockscout.com/api',
          browserURL: 'https://base-sepolia.blockscout.com',
        },
      },
    ],
  },
  sourcify: {
    enabled: true,
  },
  abiExporter: {
    path: './abi',
    clear: true,
  },
  typechain: {
    outDir: './typechain',
  },
  gasReporter: {
    enabled: !process.env.CI,
    currency: 'USD',
    gasPrice: 50,
    src: 'contracts',
    coinmarketcap: '7643dfc7-a58f-46af-8314-2db32bdd18ba',
  },
  mocha: {
    timeout: 60_000,
  },
};
export default config;
