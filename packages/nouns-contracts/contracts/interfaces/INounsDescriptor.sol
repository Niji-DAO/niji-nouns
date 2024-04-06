// SPDX-License-Identifier: GPL-3.0

/// @title Interface for NounsDescriptor

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
// This file is a modified version of nounsDAO's INounsDescriptor.sol:
// https://github.com/nounsDAO/nouns-monorepo/blob/854b9b64770401da71503972c65c4f9eda060ba6/packages/nouns-contracts/contracts/interfaces/INounsDescriptor.sol
//
// INounsDescriptor.sol licensed under the GPL-3.0 license.
// With modifications by NijiNouns DAO.

import { INounsSeeder } from './INounsSeeder.sol';
import { INounsDescriptorMinimal } from './INounsDescriptorMinimal.sol';

interface INounsDescriptor is INounsDescriptorMinimal {
    event PartsLocked();

    event DataURIToggled(bool enabled);

    event BaseURIUpdated(string baseURI);

    function arePartsLocked() external returns (bool);

    function isDataURIEnabled() external returns (bool);

    function baseURI() external returns (string memory);

    function palettes(uint8 paletteIndex, uint256 colorIndex) external view returns (string memory);

    function backgrounds(uint256 index) external view returns (string memory);

    function specials(uint256 index) external view returns (bytes memory);

    function chokers(uint256 index) external view returns (bytes memory);

    function headphones(uint256 index) external view returns (bytes memory);

    function leftHands(uint256 index) external view returns (bytes memory);

    function hats(uint256 index) external view returns (bytes memory);

    function clothes(uint256 index) external view returns (bytes memory);

    function ears(uint256 index) external view returns (bytes memory);

    function backs(uint256 index) external view returns (bytes memory);

    function backDecorations(uint256 index) external view returns (bytes memory);

    function backgroundDecorations(uint256 index) external view returns (bytes memory);

    function hairs(uint256 index) external view returns (bytes memory);

    function backgroundCount() external view override returns (uint256);

    function specialCount() external view override returns (uint256);

    function chokerCount() external view override returns (uint256);

    function headphoneCount() external view override returns (uint256);

    function leftHandCount() external view override returns (uint256);

    function hatCount() external view override returns (uint256);

    function clotheCount() external view override returns (uint256);

    function earCount() external view override returns (uint256);

    function backCount() external view override returns (uint256);

    function backDecorationCount() external view override returns (uint256);

    function backgroundDecorationCount() external view override returns (uint256);

    function hairCount() external view override returns (uint256);

    function addManyColorsToPalette(uint8 paletteIndex, string[] calldata newColors) external;

    function addManyBackgrounds(string[] calldata backgrounds) external;

    function addManySpecials(bytes[] calldata specials) external;

    function addManyChokers(bytes[] calldata chokers) external;

    function addManyHeadphones(bytes[] calldata headphones) external;

    function addManyLeftHands(bytes[] calldata leftHands) external;

    function addManyHats(bytes[] calldata hats) external;

    function addManyClothes(bytes[] calldata clothes) external;

    function addManyEars(bytes[] calldata ears) external;

    function addManyBacks(bytes[] calldata backs) external;

    function addManyBackDecorations(bytes[] calldata backDecorations) external;

    function addManyBackgroundDecorations(bytes[] calldata backgroundDecorations) external;

    function addManyHairs(bytes[] calldata hairs) external;

    function addColorToPalette(uint8 paletteIndex, string calldata color) external;

    function addBackground(string calldata background) external;

    function addSpecial(bytes calldata special) external;

    function addChoker(bytes calldata choker) external;

    function addHeadphone(bytes calldata headphone) external;

    function addLeftHand(bytes calldata leftHand) external;

    function addHat(bytes calldata hats) external;

    function addClothe(bytes calldata clothe) external;

    function addEar(bytes calldata ear) external;

    function addBack(bytes calldata back) external;

    function addBackDecoration(bytes calldata backDecoration) external;

    function addBackgroundDecoration(bytes calldata backgroundDecoration) external;

    function addHair(bytes calldata hair) external;

    function lockParts() external;

    function toggleDataURIEnabled() external;

    function setBaseURI(string calldata baseURI) external;

    function tokenURI(uint256 tokenId, INounsSeeder.Seed memory seed) external view override returns (string memory);

    function dataURI(uint256 tokenId, INounsSeeder.Seed memory seed) external view override returns (string memory);

    function genericDataURI(
        string calldata name,
        string calldata description,
        INounsSeeder.Seed memory seed
    ) external view returns (string memory);

    function generateSVGImage(INounsSeeder.Seed memory seed) external view returns (string memory);
}
