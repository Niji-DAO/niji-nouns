// SPDX-License-Identifier: GPL-3.0

/// @title Interface for NounsArt

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
// This file is a modified version of nounsDAO's INounsArt.sol:
// https://github.com/nounsDAO/nouns-monorepo/blob/854b9b64770401da71503972c65c4f9eda060ba6/packages/nouns-contracts/contracts/interfaces/INounsArt.sol
//
// INounsArt.sol licensed under the GPL-3.0 license.
// With modifications by NijiNouns DAO.

import { Inflate } from '../libs/Inflate.sol';
import { IInflator } from './IInflator.sol';

interface INounsArt {
    error SenderIsNotDescriptor();

    error EmptyPalette();

    error BadPaletteLength();

    error EmptyBytes();

    error BadDecompressedLength();

    error BadImageCount();

    error ImageNotFound();

    error PaletteNotFound();

    event DescriptorUpdated(address oldDescriptor, address newDescriptor);

    event InflatorUpdated(address oldInflator, address newInflator);

    event BackgroundsAdded(uint256 count);

    event PaletteSet(uint8 paletteIndex);

    event SpecialsAdded(uint16 count);

    event ChokersAdded(uint16 count);

    event HeadphonesAdded(uint16 count);

    event LeftHandsAdded(uint16 count);

    event HatsAdded(uint16 count);

    event ClothesAdded(uint16 count);

    event EarsAdded(uint16 count);

    event BacksAdded(uint16 count);

    event BackDecorationsAdded(uint16 count);

    event BackgroundDecorationsAdded(uint16 count);

    event HairsAdded(uint16 count);

    struct NounArtStoragePage {
        uint16 imageCount;
        uint80 decompressedLength;
        address pointer;
    }

    struct Trait {
        NounArtStoragePage[] storagePages;
        uint256 storedImagesCount;
    }

    function getImagePart(string memory category, uint256 number) external view returns (string memory);

    function descriptor() external view returns (address);

    function inflator() external view returns (IInflator);

    function setDescriptor(address descriptor) external;

    function setInflator(IInflator inflator) external;

    function addManyBackgrounds(string[] calldata _backgrounds) external;

    function addBackground(string calldata _background) external;

    function palettes(uint8 paletteIndex) external view returns (bytes memory);

    function setPalette(uint8 paletteIndex, bytes calldata palette) external;

    function addSpecials(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addSpecials(string[] calldata identifiers) external;

    function addChokers(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addChokers(string[] calldata identifiers) external;

    function addHeadphones(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addHeadphones(string[] calldata identifiers) external;

    function addLeftHands(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addLeftHands(string[] calldata identifiers) external;

    function addHats(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addHats(string[] calldata identifiers) external;

    function addClothes(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addClothes(string[] calldata identifiers) external;

    function addEars(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addEars(string[] calldata identifiers) external;

    function addBacks(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addBacks(string[] calldata identifiers) external;

    function addBackDecorations(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addBackDecorations(string[] calldata identifiers) external;

    function addBackgroundDecorations(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addBackgroundDecorations(string[] calldata identifiers) external;

    function addHairs(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addHairs(string[] calldata identifiers) external;

    function addSpecialsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addChokersFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addHeadphonesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addLeftHandsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addHatsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addClothesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addEarsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addBacksFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addBackDecorationsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addBackgroundDecorationsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function addHairsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external;

    function setPalettePointer(uint8 paletteIndex, address pointer) external;

    function backgroundsCount() external view returns (uint256);

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

    function getBackgroundDecorationsTrait() external view returns (Trait memory);

    function getSpecialsTrait() external view returns (Trait memory);

    function getLeftHandsTrait() external view returns (Trait memory);

    function getBacksTrait() external view returns (Trait memory);

    function getEarsTrait() external view returns (Trait memory);

    function getChokersTrait() external view returns (Trait memory);

    function getClothesTrait() external view returns (Trait memory);

    function getHairsTrait() external view returns (Trait memory);

    function getHeadphonesTrait() external view returns (Trait memory);

    function getHatsTrait() external view returns (Trait memory);

    function getBackDecorationsTrait() external view returns (Trait memory);

    function getBackgroundDecorationsCount() external view returns (uint256);

    function getSpecialsCount() external view returns (uint256);

    function getLeftHandsCount() external view returns (uint256);

    function getBacksCount() external view returns (uint256);

    function getEarsCount() external view returns (uint256);

    function getChokersCount() external view returns (uint256);

    function getClothesCount() external view returns (uint256);

    function getHairsCount() external view returns (uint256);

    function getHeadphonesCount() external view returns (uint256);

    function getHatsCount() external view returns (uint256);

    function getBackDecorationsCount() external view returns (uint256);


}
