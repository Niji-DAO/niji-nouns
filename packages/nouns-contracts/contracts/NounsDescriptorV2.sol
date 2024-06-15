// SPDX-License-Identifier: GPL-3.0

/// @title The NijiNouns NFT descriptor

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
// This file is a modified version of nounsDAO's NounsDescriptorV2.sol:
// https://github.com/nounsDAO/nouns-monorepo/blob/854b9b64770401da71503972c65c4f9eda060ba6/packages/nouns-contracts/contracts/NounsDescriptorV2.sol
//
// NounsDescriptorV2.sol licensed under the GPL-3.0 license.
// With modifications by NijiNouns DAO.

import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';
import { Strings } from '@openzeppelin/contracts/utils/Strings.sol';
import { INounsDescriptorV2 } from './interfaces/INounsDescriptorV2.sol';
import { INounsSeeder } from './interfaces/INounsSeeder.sol';
import { NFTDescriptorV2 } from './libs/NFTDescriptorV2.sol';
import { ISVGRenderer } from './interfaces/ISVGRenderer.sol';
import { INounsArt } from './interfaces/INounsArt.sol';
import { IInflator } from './interfaces/IInflator.sol';
import 'hardhat/console.sol';

contract NounsDescriptorV2 is INounsDescriptorV2, Ownable {
    using Strings for uint256;

    // prettier-ignore
    // https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt
    bytes32 constant COPYRIGHT_CC0_1_0_UNIVERSAL_LICENSE = 0xa2010f343487d3f7618affe54f789f5487602331c0a8d03f49e9a7c547cf0499;

    /// @notice The contract responsible for holding compressed Noun art
    INounsArt public art;

    /// @notice The contract responsible for constructing SVGs
    ISVGRenderer public renderer;

    /// @notice Whether or not new Noun parts can be added
    bool public override arePartsLocked;

    /// @notice Whether or not `tokenURI` should be returned as a data URI (Default: true)
    bool public override isDataURIEnabled = true;

    /// @notice Base URI, used when isDataURIEnabled is false
    string public override baseURI;

    /**
     * @notice Require that the parts have not been locked.
     */
    modifier whenPartsNotLocked() {
        require(!arePartsLocked, 'Parts are locked');
        _;
    }

    constructor(INounsArt _art, ISVGRenderer _renderer) {
        art = _art;
        renderer = _renderer;
    }

    /**
     * @notice Set the Noun's art contract.
     * @dev Only callable by the owner when not locked.
     */
    function setArt(INounsArt _art) external onlyOwner whenPartsNotLocked {
        art = _art;

        emit ArtUpdated(_art);
    }

    /**
     * @notice Set the SVG renderer.
     * @dev Only callable by the owner.
     */
    function setRenderer(ISVGRenderer _renderer) external onlyOwner {
        renderer = _renderer;

        emit RendererUpdated(_renderer);
    }

    /**
     * @notice Set the art contract's `descriptor`.
     * @param descriptor the address to set.
     * @dev Only callable by the owner.
     */
    function setArtDescriptor(address descriptor) external onlyOwner {
        art.setDescriptor(descriptor);
    }

    /**
     * @notice Set the art contract's `inflator`.
     * @param inflator the address to set.
     * @dev Only callable by the owner.
     */
    function setArtInflator(IInflator inflator) external onlyOwner {
        art.setInflator(inflator);
    }

    /**
     * @notice Get the number of available Noun `backgrounds`.
     */
    function backgroundCount() external view override returns (uint256) {
        return art.backgroundsCount();
    }

    /**
     * @notice Get the number of available Noun `specials`.
     */
    function specialCount() external view override returns (uint256) {
        // return art.getSpecialsTrait().storedImagesCount;
        return art.getSpecialsCount();
    }

    /**
     * @notice Get the number of available Noun `chokers`.
     */
    function chokerCount() external view override returns (uint256) {
        // return art.getChokersTrait().storedImagesCount;
        return art.getChokersCount();
    }

    /**
     * @notice Get the number of available Noun `headphones`.
     */
    function headphoneCount() external view override returns (uint256) {
        // return art.getHeadphonesTrait().storedImagesCount;
        return art.getHeadphonesCount();
    }

    /**
     * @notice Get the number of available Noun `leftHands`.
     */
    function leftHandCount() external view override returns (uint256) {
        // return art.getLeftHandsTrait().storedImagesCount;
        return art.getLeftHandsCount();
    }

    /**
     * @notice Get the number of available Noun `hats`.
     */
    function hatCount() external view override returns (uint256) {
        // return art.getHatsTrait().storedImagesCount;
        return art.getHatsCount();
    }

    /**
     * @notice Get the number of available Noun `clothes`.
     */
    function clotheCount() external view override returns (uint256) {
        // return art.getClothesTrait().storedImagesCount;
        return art.getClothesCount();
    }

    /**
     * @notice Get the number of available Noun `ears`.
     */
    function earCount() external view override returns (uint256) {
        // return art.getEarsTrait().storedImagesCount;
        return art.getEarsCount();
    }

    /**
     * @notice Get the number of available Noun `backs`.
     */
    function backCount() external view override returns (uint256) {
        // return art.getBacksTrait().storedImagesCount;
        return art.getBacksCount();
    }

    /**
     * @notice Get the number of available Noun `backDecorations`.
     */
    function backDecorationCount() external view override returns (uint256) {
        // return art.getBackDecorationsTrait().storedImagesCount;
        return art.getBackDecorationsCount();
    }

    /**
     * @notice Get the number of available Noun `backgroundDecorations`.
     */
    function backgroundDecorationCount() external view override returns (uint256) {
        // return art.getBackgroundDecorationsTrait().storedImagesCount;
        return art.getBackgroundDecorationsCount();
    }

    /**
     * @notice Get the number of available Noun `hairs`.
     */
    function hairCount() external view override returns (uint256) {
        // return art.getHairsTrait().storedImagesCount;
        return art.getHairsCount();
    }


    /**
     * @notice Batch add Noun backgrounds.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyBackgrounds(string[] calldata _backgrounds) external override onlyOwner whenPartsNotLocked {
        art.addManyBackgrounds(_backgrounds);
    }

    /**
     * @notice Add a Noun background.
     * @dev This function can only be called by the owner when not locked.
     */
    function addBackground(string calldata _background) external override onlyOwner whenPartsNotLocked {
        art.addBackground(_background);
    }

    /**
     * @notice Update a single color palette. This function can be used to
     * add a new color palette or update an existing palette.
     * @param paletteIndex the identifier of this palette
     * @param palette byte array of colors. every 3 bytes represent an RGB color. max length: 256 * 3 = 768
     * @dev This function can only be called by the owner when not locked.
     */
    function setPalette(uint8 paletteIndex, bytes calldata palette) external override onlyOwner whenPartsNotLocked {
        art.setPalette(paletteIndex, palette);
    }

    /**
     * @notice Add a batch of special images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addSpecials(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addSpecials(encodedCompressed, decompressedLength, imageCount);
    }

    function addSpecialIdentifiers(string[] calldata identifiers) external override onlyOwner whenPartsNotLocked {
        art.addSpecials(identifiers);
    }

    /**
     * @notice Add a batch of choker images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addChokers(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addChokers(encodedCompressed, decompressedLength, imageCount);
    }

    function addChokerIdentifiers(string[] calldata identifiers) external override onlyOwner whenPartsNotLocked {
        art.addChokers(identifiers);
    }

    /**
     * @notice Add a batch of headphone images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addHeadphones(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addHeadphones(encodedCompressed, decompressedLength, imageCount);
    }

    function addHeadphoneIdentifiers(string[] calldata identifiers) external override onlyOwner whenPartsNotLocked {
        art.addHeadphones(identifiers);
    }

    /**
     * @notice Add a batch of leftHand images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addLeftHands(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addLeftHands(encodedCompressed, decompressedLength, imageCount);
    }

    function addLeftHandIdentifiers(string[] calldata identifiers) external override onlyOwner whenPartsNotLocked {
        art.addLeftHands(identifiers);
    }

    /**
     * @notice Add a batch of hat images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addHats(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addHats(encodedCompressed, decompressedLength, imageCount);
    }

    function addHatIdentifiers(string[] calldata identifiers) external override onlyOwner whenPartsNotLocked {
        art.addHats(identifiers);
    }

    /**
     * @notice Add a batch of clothe images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addClothes(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addClothes(encodedCompressed, decompressedLength, imageCount);
    }

    function addClotheIdentifiers(string[] calldata identifiers) external override onlyOwner whenPartsNotLocked {
        art.addClothes(identifiers);
    }

    /**
     * @notice Add a batch of ear images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addEars(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addEars(encodedCompressed, decompressedLength, imageCount);
    }

    function addEarIdentifiers(string[] calldata identifiers) external override onlyOwner whenPartsNotLocked {
        art.addEars(identifiers);
    }

    /**
     * @notice Add a batch of back images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addBacks(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addBacks(encodedCompressed, decompressedLength, imageCount);
    }

    function addBackIdentifiers(string[] calldata identifiers) external override onlyOwner whenPartsNotLocked {
        art.addBacks(identifiers);
    }

    /**
     * @notice Add a batch of backDecoration images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addBackDecorations(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addBackDecorations(encodedCompressed, decompressedLength, imageCount);
    }

    function addBackDecorationIdentifiers(string[] calldata identifiers) external override onlyOwner whenPartsNotLocked {
        art.addBackDecorations(identifiers);
    }

    /**
     * @notice Add a batch of backgroundDecoration images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addBackgroundDecorations(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addBackgroundDecorations(encodedCompressed, decompressedLength, imageCount);
    }

    function addBackgroundDecorationIdentifiers(string[] calldata identifiers) external override onlyOwner whenPartsNotLocked {
        art.addBackgroundDecorations(identifiers);
    }

    /**
     * @notice Add a batch of hair images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addHairs(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addHairs(encodedCompressed, decompressedLength, imageCount);
    }

    function addHairIdentifiers(string[] calldata identifiers) external onlyOwner whenPartsNotLocked {
        art.addHairs(identifiers);
    }

    /**
     * @notice Update a single color palette. This function can be used to
     * add a new color palette or update an existing palette. This function does not check for data length validity
     * (len <= 768, len % 3 == 0).
     * @param paletteIndex the identifier of this palette
     * @param pointer the address of the contract holding the palette bytes. every 3 bytes represent an RGB color.
     * max length: 256 * 3 = 768.
     * @dev This function can only be called by the owner when not locked.
     */
    function setPalettePointer(uint8 paletteIndex, address pointer) external override onlyOwner whenPartsNotLocked {
        art.setPalettePointer(paletteIndex, pointer);
    }

    /**
     * @notice Add a batch of special images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addSpecialsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addSpecialsFromPointer(pointer, decompressedLength, imageCount);
    }

    /**
     * @notice Add a batch of choker images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addChokersFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addChokersFromPointer(pointer, decompressedLength, imageCount);
    }

    /**
     * @notice Add a batch of headphone images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addHeadphonesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addHeadphonesFromPointer(pointer, decompressedLength, imageCount);
    }

    /**
     * @notice Add a batch of leftHand images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addLeftHandsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addLeftHandsFromPointer(pointer, decompressedLength, imageCount);
    }

    /**
     * @notice Add a batch of hat images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addHatsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addHatsFromPointer(pointer, decompressedLength, imageCount);
    }

    /**
     * @notice Add a batch of clothe images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addClothesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addClothesFromPointer(pointer, decompressedLength, imageCount);
    }

    /**
     * @notice Add a batch of ear images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addEarsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addEarsFromPointer(pointer, decompressedLength, imageCount);
    }

    /**
     * @notice Add a batch of back images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addBacksFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addBacksFromPointer(pointer, decompressedLength, imageCount);
    }

    /**
     * @notice Add a batch of backDecoration images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addBackDecorationsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addBackDecorationsFromPointer(pointer, decompressedLength, imageCount);
    }

    /**
     * @notice Add a batch of backgroundDecoration images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addBackgroundDecorationsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addBackgroundDecorationsFromPointer(pointer, decompressedLength, imageCount);
    }

    /**
     * @notice Add a batch of hair images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the owner when not locked.
     */
    function addHairsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyOwner whenPartsNotLocked {
        art.addHairsFromPointer(pointer, decompressedLength, imageCount);
    }

    /**
     * @notice Get a background color by ID.
     * @param index the index of the background.
     * @return string the RGB hex value of the background.
     */
    function backgrounds(uint256 index) public view override returns (string memory) {
        return art.backgrounds(index);
    }

    /**
     * @notice Get a special image by ID.
     * @param index the index of the head.
     * @return bytes the RLE-encoded bytes of the image.
     */
    function specials(uint256 index) public view override returns (bytes memory) {
        return art.specials(index);
    }

    /**
     * @notice Get a choker image by ID.
     * @param index the index of the head.
     * @return bytes the RLE-encoded bytes of the image.
     */
    function chokers(uint256 index) public view override returns (bytes memory) {
        return art.chokers(index);
    }

    /**
     * @notice Get a headphone image by ID.
     * @param index the index of the head.
     * @return bytes the RLE-encoded bytes of the image.
     */
    function headphones(uint256 index) public view override returns (bytes memory) {
        return art.headphones(index);
    }

    /**
     * @notice Get a leftHand image by ID.
     * @param index the index of the head.
     * @return bytes the RLE-encoded bytes of the image.
     */
    function leftHands(uint256 index) public view override returns (bytes memory) {
        return art.leftHands(index);
    }

    /**
     * @notice Get a hat image by ID.
     * @param index the index of the head.
     * @return bytes the RLE-encoded bytes of the image.
     */
    function hats(uint256 index) public view override returns (bytes memory) {
        return art.hats(index);
    }

    /**
     * @notice Get a clothe image by ID.
     * @param index the index of the head.
     * @return bytes the RLE-encoded bytes of the image.
     */
    function clothes(uint256 index) public view override returns (bytes memory) {
        return art.clothes(index);
    }

    /**
     * @notice Get a ear image by ID.
     * @param index the index of the head.
     * @return bytes the RLE-encoded bytes of the image.
     */
    function ears(uint256 index) public view override returns (bytes memory) {
        return art.ears(index);
    }

    /**
     * @notice Get a back image by ID.
     * @param index the index of the head.
     * @return bytes the RLE-encoded bytes of the image.
     */
    function backs(uint256 index) public view override returns (bytes memory) {
        return art.backs(index);
    }

    /**
     * @notice Get a backDecoration image by ID.
     * @param index the index of the head.
     * @return bytes the RLE-encoded bytes of the image.
     */
    function backDecorations(uint256 index) public view override returns (bytes memory) {
        return art.backDecorations(index);
    }

    /**
     * @notice Get a backgroundDecoration image by ID.
     * @param index the index of the head.
     * @return bytes the RLE-encoded bytes of the image.
     */
    function backgroundDecorations(uint256 index) public view override returns (bytes memory) {
        return art.backgroundDecorations(index);
    }

    /**
     * @notice Get a hair image by ID.
     * @param index the index of the head.
     * @return bytes the RLE-encoded bytes of the image.
     */
    function hairs(uint256 index) public view override returns (bytes memory) {
        return art.hairs(index);
    }


    /**
     * @notice Get a color palette by ID.
     * @param index the index of the palette.
     * @return bytes the palette bytes, where every 3 consecutive bytes represent a color in RGB format.
     */
    function palettes(uint8 index) public view override returns (bytes memory) {
        return art.palettes(index);
    }

    /**
     * @notice Lock all Noun parts.
     * @dev This cannot be reversed and can only be called by the owner when not locked.
     */
    function lockParts() external override onlyOwner whenPartsNotLocked {
        arePartsLocked = true;

        emit PartsLocked();
    }

    /**
     * @notice Toggle a boolean value which determines if `tokenURI` returns a data URI
     * or an HTTP URL.
     * @dev This can only be called by the owner.
     */
    function toggleDataURIEnabled() external override onlyOwner {
        bool enabled = !isDataURIEnabled;

        isDataURIEnabled = enabled;
        emit DataURIToggled(enabled);
    }

    /**
     * @notice Set the base URI for all token IDs. It is automatically
     * added as a prefix to the value returned in {tokenURI}, or to the
     * token ID if {tokenURI} is empty.
     * @dev This can only be called by the owner.
     */
    function setBaseURI(string calldata _baseURI) external override onlyOwner {
        baseURI = _baseURI;

        emit BaseURIUpdated(_baseURI);
    }

    /**
     * @notice Given a token ID and seed, construct a token URI for an official NijiNouns DAO noun.
     * @dev The returned value may be a base64 encoded data URI or an API URL.
     */
    function tokenURI(uint256 tokenId, INounsSeeder.Seed memory seed) external view override returns (string memory) {
        if (isDataURIEnabled) {
            console.log("tokenURI");
            return dataURI(tokenId, seed);
        }
        return string(abi.encodePacked(baseURI, tokenId.toString()));
    }

    /**
     * @notice Given a token ID and seed, construct a base64 encoded data URI for an official NijiNouns DAO noun.
     */
    function dataURI(uint256 tokenId, INounsSeeder.Seed memory seed) public view override returns (string memory) {
        string memory nounId = tokenId.toString();
        string memory name = string(abi.encodePacked('NijiNoun ', nounId));
        string memory description = string(abi.encodePacked('NijiNoun ', nounId, ' is a member of the Niji DAO'));

        console.log("dataURI");

        return genericDataURI(name, description, seed);
    }

    /**
     * @notice Given a name, description, and seed, construct a base64 encoded data URI.
     */
    function genericDataURI(
        string memory name,
        string memory description,
        INounsSeeder.Seed memory seed
    ) public view override returns (string memory) {
        console.log("genericDataURI");
        NFTDescriptorV2.TokenURIParams memory params = NFTDescriptorV2.TokenURIParams({
            name: name,
            description: description,
            parts: getPartsForSeed(seed),
            background: art.backgrounds(seed.background)
        });
        console.log("call NFTDescriptorV2.constructTokenURI");
        return NFTDescriptorV2.constructTokenURI(renderer, params);
    }

    /**
     * @notice Given a seed, construct a base64 encoded SVG image.
     */
    function generateSVGImage(INounsSeeder.Seed memory seed) external view override returns (string memory) {
        ISVGRenderer.SVGParams memory params = ISVGRenderer.SVGParams({
            parts: getPartsForSeed(seed),
            background: art.backgrounds(seed.background)
        });
        return NFTDescriptorV2.generateSVGImage(renderer, params);
    }

    /**
     * @notice Get all Noun parts for the passed `seed`.
     */
    function getPartsForSeed(INounsSeeder.Seed memory seed) public view returns (ISVGRenderer.Part[] memory) {
        ISVGRenderer.Part[] memory parts = new ISVGRenderer.Part[](11);
        console.log("start getPartsForSeed");
        {
            bytes memory backgroundDecoration = art.backgroundDecorations(seed.backgroundDecoration);
            parts[0] = ISVGRenderer.Part({ image: backgroundDecoration, palette: _getPalette(backgroundDecoration) });
            // parts[0] = ISVGRenderer.Part({ image: bytes(art.getImagePart('backgroundDecorations', seed.backgroundDecoration)), palette: "" });
        }
        console.log("backgroundDecoration");
        {
            bytes memory special = art.specials(seed.special);
            parts[1] = ISVGRenderer.Part({ image: special, palette: _getPalette(special) });
            // parts[1] = ISVGRenderer.Part({ image: bytes(art.getImagePart('specials', seed.special)), palette: "" });
        }
        console.log("special");
        {
            bytes memory leftHand = art.leftHands(seed.leftHand);
            parts[2] = ISVGRenderer.Part({ image: leftHand, palette: _getPalette(leftHand) });
            // parts[2] = ISVGRenderer.Part({ image: bytes(art.getImagePart('leftHands', seed.leftHand)), palette: "" });
        }
        console.log("leftHand");
        {
            bytes memory back = art.backs(seed.back);
            parts[3] = ISVGRenderer.Part({ image: back, palette: _getPalette(back) });
            // parts[3] = ISVGRenderer.Part({ image: bytes(art.getImagePart('backs', seed.back)), palette: "" });
        }
        console.log("back");
        {
            bytes memory ear = art.ears(seed.ear);
            parts[4] = ISVGRenderer.Part({ image: ear, palette: _getPalette(ear) });
            // parts[4] = ISVGRenderer.Part({ image: bytes(art.getImagePart('ears', seed.ear)), palette: "" });
        }
        console.log("ear");
        {
            bytes memory choker = art.chokers(seed.choker);
            parts[5] = ISVGRenderer.Part({ image: choker, palette: _getPalette(choker) });
            // parts[5] = ISVGRenderer.Part({ image: bytes(art.getImagePart('chokers', seed.choker)), palette: "" });
        }
        console.log("choker");
        {
            bytes memory clothe = art.clothes(seed.clothe);
            parts[6] = ISVGRenderer.Part({ image: clothe, palette: _getPalette(clothe) });
            // parts[6] = ISVGRenderer.Part({ image: bytes(art.getImagePart('clothes', seed.clothe)), palette: "" });
        }
        console.log("clothe");
        {
            bytes memory hair = art.hairs(seed.hair);
            parts[7] = ISVGRenderer.Part({ image: hair, palette: _getPalette(hair) });
            // parts[7] = ISVGRenderer.Part({ image: bytes(art.getImagePart('hairs', seed.hair)), palette: "" });
        }
        console.log("hair");
        {
            bytes memory headphone = art.headphones(seed.headphone);
            parts[8] = ISVGRenderer.Part({ image: headphone, palette: _getPalette(headphone) });
            // parts[8] = ISVGRenderer.Part({ image: bytes(art.getImagePart('headphones', seed.headphone)), palette: "" });
        }
        console.log("headphone");
        {
            bytes memory hat = art.hats(seed.hat);
            parts[9] = ISVGRenderer.Part({ image: hat, palette: _getPalette(hat) });
            // parts[9] = ISVGRenderer.Part({ image: bytes(art.getImagePart('hats', seed.hat)), palette: "" });
        }
        console.log("hat");
        {
            bytes memory backDecoration = art.backDecorations(seed.backDecoration);
            parts[10] = ISVGRenderer.Part({ image: backDecoration, palette: _getPalette(backDecoration) });
            // parts[10] = ISVGRenderer.Part({ image: bytes(art.getImagePart('backDecorations', seed.backDecoration)), palette: "" });
        }
        console.log("backDecoration");
        console.log("end getPartsForSeed");
        return parts;
    }

    /**
     * @notice Get the color palette pointer for the passed part.
     */
    function _getPalette(bytes memory part) private view returns (bytes memory) {
        return art.palettes(uint8(part[0]));
    }
}
