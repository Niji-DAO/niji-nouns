// SPDX-License-Identifier: GPL-3.0

/// @title Interface for NounsSeeder

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
// This file is a modified version of nounsDAO's INounsSeeder.sol:
// https://github.com/nounsDAO/nouns-monorepo/blob/854b9b64770401da71503972c65c4f9eda060ba6/packages/nouns-contracts/contracts/interfaces/INounsSeeder.sol
//
// INounsSeeder.sol licensed under the GPL-3.0 license.
// With modifications by NijiNouns DAO.

import { INounsDescriptorMinimal } from './INounsDescriptorMinimal.sol';

interface INounsSeeder {
    struct Seed {
        uint256 background;
        uint256 backgroundDecoration;
        uint256 back;
        uint256 special;
        uint256 clothe;
        uint256 backDecoration;
        uint256 choker;
        uint256 ear;
        uint256 hair;
        uint256 headphone;
        uint256 hat;
        uint256 leftHand;
    }

    function generateSeed(uint256 nounId, INounsDescriptorMinimal descriptor) external view returns (Seed memory);
}
