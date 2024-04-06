// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.15;

// LICENSE
// This file is a modified version of nounsDAO's NounsTokenHarness.sol:
// https://github.com/nounsDAO/nouns-monorepo/blob/854b9b64770401da71503972c65c4f9eda060ba6/packages/nouns-contracts/contracts/test/NounsTokenHarness.sol
//
// NounsTokenHarness.sol licensed under the GPL-3.0 license.
// With modifications by NijiNouns DAO.

import { NounsToken } from '../NounsToken.sol';
import { INounsDescriptorMinimal } from '../interfaces/INounsDescriptorMinimal.sol';
import { INounsSeeder } from '../interfaces/INounsSeeder.sol';
import { IProxyRegistry } from '../external/opensea/IProxyRegistry.sol';

contract NounsTokenHarness is NounsToken {
    uint256 public currentNounId;

    constructor(
        address noundersDAO,
        address minter,
        INounsDescriptorMinimal descriptor,
        INounsSeeder seeder,
        IProxyRegistry proxyRegistry
    ) NounsToken(noundersDAO, minter, descriptor, seeder, proxyRegistry) {}

    function mintTo(address to) public {
        _mintTo(to, currentNounId++);
    }

    function mintMany(address to, uint256 amount) public {
        for (uint256 i = 0; i < amount; i++) {
            mintTo(to);
        }
    }

    function mintSeed(
        address to,
        uint256 background,
        uint256 special,
        uint256 choker,
        uint256 headphone,
        uint256 leftHand,
        uint256 hat,
        uint256 clothe,
        uint256 ear,
        uint256 back,
        uint256 backDecoration,
        uint256 backgroundDecoration,
        uint256 hair
    ) public {
        seeds[currentNounId] = INounsSeeder.Seed({
            background: background,
            special: special,
            choker: choker,
            headphone: headphone,
            leftHand: leftHand,
            hat: hat,
            clothe: clothe,
            ear: ear,
            back: back,
            backDecoration: backDecoration,
            backgroundDecoration: backgroundDecoration,
            hair: hair
        });

        _mint(owner(), to, currentNounId++);
    }
}
