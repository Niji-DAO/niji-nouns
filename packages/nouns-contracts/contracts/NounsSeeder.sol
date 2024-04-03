// SPDX-License-Identifier: GPL-3.0

/// @title The NounsToken pseudo-random seed generator

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
// This file is a modified version of nounsDAO's NounsSeeder.sol:
// https://github.com/nounsDAO/nouns-monorepo/blob/854b9b64770401da71503972c65c4f9eda060ba6/packages/nouns-contracts/contracts/NounsSeeder.sol
//
// NounsSeeder.sol licensed under the GPL-3.0 license.
// With modifications by NijiNouns DAO.

import { INounsSeeder } from './interfaces/INounsSeeder.sol';
import { INounsDescriptorMinimal } from './interfaces/INounsDescriptorMinimal.sol';

contract NounsSeeder is INounsSeeder {
    /**
     * @notice Generate a pseudo-random Noun seed using the previous blockhash and noun ID.
     */
    // prettier-ignore
    function generateSeed(uint256 nounId, INounsDescriptorMinimal descriptor) external view override returns (Seed memory) {
        uint256 pseudorandomness = uint256(
            keccak256(abi.encodePacked(blockhash(block.number - 1), nounId))
        );

        uint256 backgroundCount = descriptor.backgroundCount();
        uint256 specialCount = descriptor.specialCount();
        uint256 chokerCount = descriptor.chokerCount();
        uint256 headphoneCount = descriptor.headphoneCount();
        uint256 leftHandCount = descriptor.leftHandCount();
        uint256 hatCount = descriptor.hatCount();
        uint256 clotheCount = descriptor.clotheCount();
        uint256 earCount = descriptor.earCount();
        uint256 backCount = descriptor.backCount();
        uint256 backDecorationCount = descriptor.backDecorationCount();
        uint256 backgroundDecorationCount = descriptor.backgroundDecorationCount();
        uint256 hairCount = descriptor.hairCount();

        return Seed({
            background: uint48(
                uint48(pseudorandomness) % backgroundCount
            ),
            backgroundDecoration: uint48(
                uint48(pseudorandomness >> 48) % backgroundDecorationCount
            ),
            back: uint48(
                uint48(pseudorandomness >> 96) % backCount
            ),
            special: uint48(
                uint48(pseudorandomness >> 144) % specialCount
            ),
            clothe: uint48(
                uint48(pseudorandomness >> 192) % clotheCount
            ),
            backDecoration: uint48(
                uint48(pseudorandomness >> 240) % backDecorationCount
            ),
            choker: uint48(
                uint48(pseudorandomness >> 288) % chokerCount
            ),
            ear: uint48(
                uint48(pseudorandomness >> 336) % earCount
            ),
            hair: uint48(
                uint48(pseudorandomness >> 384) % hairCount
            ),
            headphone: uint48(
                uint48(pseudorandomness >> 432) % headphoneCount
            ),
            hat: uint48(
                uint48(pseudorandomness >> 480) % hatCount
            ),
            leftHand: uint48(
                uint48(pseudorandomness >> 528) % leftHandCount
            )
        });
    }
}
