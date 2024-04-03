// SPDX-License-Identifier: GPL-3.0

/// @title Common interface for NounsDescriptor versions, as used by NounsToken and NounsSeeder.

/*********************************
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░██░░░████░░██░░░████░░░ *
 * ░░██████░░░████████░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░██░░██░░░████░░██░░░████░░░ *
 * ░░░░░░█████████░░█████████░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 * ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░ *
 *********************************/

pragma solidity ^0.8.6;

// LICENSE
// This file is a modified version of nounsDAO's INounsDescriptorMinimal.sol:
// https://github.com/nounsDAO/nouns-monorepo/blob/854b9b64770401da71503972c65c4f9eda060ba6/packages/nouns-contracts/contracts/interfaces/INounsDescriptorMinimal.sol
//
// INounsDescriptorMinimal.sol licensed under the GPL-3.0 license.
// With modifications by NijiNouns DAO.

import { INounsSeeder } from './INounsSeeder.sol';

interface INounsDescriptorMinimal {
    ///
    /// USED BY TOKEN
    ///

    function tokenURI(uint256 tokenId, INounsSeeder.Seed memory seed) external view returns (string memory);

    function dataURI(uint256 tokenId, INounsSeeder.Seed memory seed) external view returns (string memory);

    ///
    /// USED BY SEEDER
    ///

    function backgroundCount() external view returns (uint256);

    function specialCount() external view returns (uint256);

    function chokerCount() external view returns (uint256);

    function headphoneCount() external view returns (uint256);

    function leftHandCount() external view returns (uint256);

    function hatCount() external view returns (uint256);

    function clotheCount() external view returns (uint256);

    function earCount() external view returns (uint256);

    function backCount() external view returns (uint256);

    function backDecorationCount() external view returns (uint256);

    function backgroundDecorationCount() external view returns (uint256);

    function hairCount() external view returns (uint256);
}
