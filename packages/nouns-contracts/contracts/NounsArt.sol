// SPDX-License-Identifier: GPL-3.0

/// @title The NijiNouns art storage contract

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
// This file is a modified version of nounsDAO's NounsArt.sol:
// https://github.com/nounsDAO/nouns-monorepo/blob/854b9b64770401da71503972c65c4f9eda060ba6/packages/nouns-contracts/contracts/NounsArt.sol
//
// NounsArt.sol licensed under the GPL-3.0 license.
// With modifications by NijiNouns DAO.

import { INounsArt } from './interfaces/INounsArt.sol';
import { SSTORE2 } from './libs/SSTORE2.sol';
import { IInflator } from './interfaces/IInflator.sol';

contract NounsArt is INounsArt {
    /// @notice Current Nouns Descriptor address
    address public override descriptor;

    /// @notice Current inflator address
    IInflator public override inflator;

    /// @notice Noun Backgrounds (Hex Colors)
    string[] public override backgrounds;

    /// @notice Noun Color Palettes (Index => Hex Colors, stored as a contract using SSTORE2)
    mapping(uint8 => address) public palettesPointers;

    /// @notice Nigi Specials Trait
    Trait public specialsTrait;

    /// @notice Nigi Chokers Trait
    Trait public chokersTrait;

    /// @notice Nigi Headphones Trait
    Trait public headphonesTrait;

    /// @notice Nigi Left Hands Trait
    Trait public leftHandsTrait;

    /// @notice Nigi Hats Trait
    Trait public hatsTrait;

    /// @notice Nigi Clothes Trait
    Trait public clothesTrait;

    /// @notice Nigi Ears Trait
    Trait public earsTrait;

    /// @notice Nigi Backs Trait
    Trait public backsTrait;

    /// @notice Nigi Back Decorations Trait
    Trait public backDecorationsTrait;

    /// @notice Nigi Background Decorations Trait
    Trait public backgroundDecorationsTrait;

    /// @notice Nigi Hairs Trait
    Trait public hairsTrait;

    /**
     * @notice Require that the sender is the descriptor.
     */
    modifier onlyDescriptor() {
        if (msg.sender != descriptor) {
            revert SenderIsNotDescriptor();
        }
        _;
    }

    constructor(address _descriptor, IInflator _inflator) {
        descriptor = _descriptor;
        inflator = _inflator;
    }

    /**
     * @notice Set the descriptor.
     * @dev This function can only be called by the current descriptor.
     */
    function setDescriptor(address _descriptor) external override onlyDescriptor {
        address oldDescriptor = descriptor;
        descriptor = _descriptor;

        emit DescriptorUpdated(oldDescriptor, descriptor);
    }

    /**
     * @notice Set the inflator.
     * @dev This function can only be called by the descriptor.
     */
    function setInflator(IInflator _inflator) external override onlyDescriptor {
        address oldInflator = address(inflator);
        inflator = _inflator;

        emit InflatorUpdated(oldInflator, address(_inflator));
    }

    /**
     * @notice Get the Trait struct for specials.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getSpecialsTrait() external view override returns (Trait memory) {
        return specialsTrait;
    }

    /**
     * @notice Get the Trait struct for chokers.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getChokersTrait() external view override returns (Trait memory) {
        return chokersTrait;
    }

    /**
     * @notice Get the Trait struct for headphones.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getHeadphonesTrait() external view override returns (Trait memory) {
        return headphonesTrait;
    }

    /**
     * @notice Get the Trait struct for left hands.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getLeftHandsTrait() external view override returns (Trait memory) {
        return leftHandsTrait;
    }

    /**
     * @notice Get the Trait struct for hats.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getHatsTrait() external view override returns (Trait memory) {
        return hatsTrait;
    }

    /**
     * @notice Get the Trait struct for clothes.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getClothesTrait() external view override returns (Trait memory) {
        return clothesTrait;
    }

    /**
     * @notice Get the Trait struct for ears.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getEarsTrait() external view override returns (Trait memory) {
        return earsTrait;
    }

    /**
     * @notice Get the Trait struct for backs.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getBacksTrait() external view override returns (Trait memory) {
        return backsTrait;
    }

    /**
     * @notice Get the Trait struct for backDecorations.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getBackDecorationsTrait() external view override returns (Trait memory) {
        return backDecorationsTrait;
    }

    /**
     * @notice Get the Trait struct for backgroundDecorations.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getBackgroundDecorationsTrait() external view override returns (Trait memory) {
        return backgroundDecorationsTrait;
    }

    /**
     * @notice Get the Trait struct for hairs.
     * @dev This explicit getter is needed because implicit getters for structs aren't fully supported yet:
     * https://github.com/ethereum/solidity/issues/11826
     * @return Trait the struct, including a total image count, and an array of storage pages.
     */
    function getHairsTrait() external view override returns (Trait memory) {
        return hairsTrait;
    }

    /**
     * @notice Batch add Noun backgrounds.
     * @dev This function can only be called by the descriptor.
     */
    function addManyBackgrounds(string[] calldata _backgrounds) external override onlyDescriptor {
        for (uint256 i = 0; i < _backgrounds.length; i++) {
            _addBackground(_backgrounds[i]);
        }

        emit BackgroundsAdded(_backgrounds.length);
    }

    /**
     * @notice Add a Noun background.
     * @dev This function can only be called by the descriptor.
     */
    function addBackground(string calldata _background) external override onlyDescriptor {
        _addBackground(_background);

        emit BackgroundsAdded(1);
    }

    /**
     * @notice Update a single color palette. This function can be used to
     * add a new color palette or update an existing palette.
     * @param paletteIndex the identifier of this palette
     * @param palette byte array of colors. every 3 bytes represent an RGB color. max length: 256 * 3 = 768
     * @dev This function can only be called by the descriptor.
     */
    function setPalette(uint8 paletteIndex, bytes calldata palette) external override onlyDescriptor {
        if (palette.length == 0) {
            revert EmptyPalette();
        }
        if (palette.length % 3 != 0 || palette.length > 768) {
            revert BadPaletteLength();
        }
        palettesPointers[paletteIndex] = SSTORE2.write(palette);

        emit PaletteSet(paletteIndex);
    }

    /**
     * @notice Add a batch of specials images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addSpecials(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(specialsTrait, encodedCompressed, decompressedLength, imageCount);

        emit SpecialsAdded(imageCount);
    }

    /**
     * @notice Add a batch of chokers images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addChokers(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(chokersTrait, encodedCompressed, decompressedLength, imageCount);

        emit ChokersAdded(imageCount);
    }

    /**
     * @notice Add a batch of headphones images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addHeadphones(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(headphonesTrait, encodedCompressed, decompressedLength, imageCount);

        emit HeadphonesAdded(imageCount);
    }

    /**
     * @notice Add a batch of leftHands images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addLeftHands(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(leftHandsTrait, encodedCompressed, decompressedLength, imageCount);

        emit LeftHandsAdded(imageCount);
    }

    /**
     * @notice Add a batch of hats images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addHats(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(hatsTrait, encodedCompressed, decompressedLength, imageCount);

        emit HatsAdded(imageCount);
    }

    /**
     * @notice Add a batch of clothes images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addClothes(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(clothesTrait, encodedCompressed, decompressedLength, imageCount);

        emit ClothesAdded(imageCount);
    }

    /**
     * @notice Add a batch of ears images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addEars(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(earsTrait, encodedCompressed, decompressedLength, imageCount);

        emit EarsAdded(imageCount);
    }

    /**
     * @notice Add a batch of backs images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addBacks(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(backsTrait, encodedCompressed, decompressedLength, imageCount);

        emit BacksAdded(imageCount);
    }

    /**
     * @notice Add a batch of backDecorations images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addBackDecorations(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(backDecorationsTrait, encodedCompressed, decompressedLength, imageCount);

        emit BackDecorationsAdded(imageCount);
    }

    /**
     * @notice Add a batch of backgroundDecorations images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addBackgroundDecorations(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(backgroundDecorationsTrait, encodedCompressed, decompressedLength, imageCount);

        emit BackgroundDecorationsAdded(imageCount);
    }

    /**
     * @notice Add a batch of hairs images.
     * @param encodedCompressed bytes created by taking a string array of RLE-encoded images, abi encoding it as a bytes array,
     * and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addHairs(
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(hairsTrait, encodedCompressed, decompressedLength, imageCount);

        emit HairsAdded(imageCount);
    }

    /**
     * @notice Update a single color palette. This function can be used to
     * add a new color palette or update an existing palette. This function does not check for data length validity
     * (len <= 768, len % 3 == 0).
     * @param paletteIndex the identifier of this palette
     * @param pointer the address of the contract holding the palette bytes. every 3 bytes represent an RGB color.
     * max length: 256 * 3 = 768.
     * @dev This function can only be called by the descriptor.
     */
    function setPalettePointer(uint8 paletteIndex, address pointer) external override onlyDescriptor {
        palettesPointers[paletteIndex] = pointer;

        emit PaletteSet(paletteIndex);
    }

    /**
     * @notice Add a batch of special images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addSpecialsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(specialsTrait, pointer, decompressedLength, imageCount);

        emit SpecialsAdded(imageCount);
    }

    /**
     * @notice Add a batch of choker images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addChokersFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(chokersTrait, pointer, decompressedLength, imageCount);

        emit ChokersAdded(imageCount);
    }

    /**
     * @notice Add a batch of headphone images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addHeadphonesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(headphonesTrait, pointer, decompressedLength, imageCount);

        emit HeadphonesAdded(imageCount);
    }

    /**
     * @notice Add a batch of left hand images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addLeftHandsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(leftHandsTrait, pointer, decompressedLength, imageCount);

        emit LeftHandsAdded(imageCount);
    }

    /**
     * @notice Add a batch of hat images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addHatsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(hatsTrait, pointer, decompressedLength, imageCount);

        emit HatsAdded(imageCount);
    }

    /**
     * @notice Add a batch of clothe images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addClothesFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(clothesTrait, pointer, decompressedLength, imageCount);

        emit ClothesAdded(imageCount);
    }

    /**
     * @notice Add a batch of ear images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addEarsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(earsTrait, pointer, decompressedLength, imageCount);

        emit EarsAdded(imageCount);
    }

    /**
     * @notice Add a batch of back images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addBacksFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(backsTrait, pointer, decompressedLength, imageCount);

        emit BacksAdded(imageCount);
    }

    /**
     * @notice Add a batch of back decoration images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addBackDecorationsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(backDecorationsTrait, pointer, decompressedLength, imageCount);

        emit BackDecorationsAdded(imageCount);
    }

    /**
     * @notice Add a batch of background decoration images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addBackgroundDecorationsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(backgroundDecorationsTrait, pointer, decompressedLength, imageCount);

        emit BackgroundDecorationsAdded(imageCount);
    }

    /**
     * @notice Add a batch of hair images from an existing storage contract.
     * @param pointer the address of a contract where the image batch was stored using SSTORE2. The data
     * format is expected to be like {encodedCompressed}: bytes created by taking a string array of
     * RLE-encoded images, abi encoding it as a bytes array, and finally compressing it using deflate.
     * @param decompressedLength the size in bytes the images bytes were prior to compression; required input for Inflate.
     * @param imageCount the number of images in this batch; used when searching for images among batches.
     * @dev This function can only be called by the descriptor.
     */
    function addHairsFromPointer(
        address pointer,
        uint80 decompressedLength,
        uint16 imageCount
    ) external override onlyDescriptor {
        addPage(hairsTrait, pointer, decompressedLength, imageCount);

        emit HairsAdded(imageCount);
    }

    /**
     * @notice Get the number of available Noun `backgrounds`.
     */
    function backgroundsCount() public view override returns (uint256) {
        return backgrounds.length;
    }

    /**
     * @notice Get a specials image bytes (RLE-encoded).
     */
    function specials(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(specialsTrait, index);
    }

    /**
     * @notice Get a chokers image bytes (RLE-encoded).
     */
    function chokers(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(chokersTrait, index);
    }

    /**
     * @notice Get a headphones image bytes (RLE-encoded).
     */
    function headphones(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(headphonesTrait, index);
    }

    /**
     * @notice Get a left hands image bytes (RLE-encoded).
     */
    function leftHands(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(leftHandsTrait, index);
    }

    /**
     * @notice Get a hats image bytes (RLE-encoded).
     */
    function hats(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(hatsTrait, index);
    }

    /**
     * @notice Get a clothes image bytes (RLE-encoded).
     */
    function clothes(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(clothesTrait, index);
    }

    /**
     * @notice Get a ears image bytes (RLE-encoded).
     */
    function ears(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(earsTrait, index);
    }

    /**
     * @notice Get a backs image bytes (RLE-encoded).
     */
    function backs(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(backsTrait, index);
    }

    /**
     * @notice Get a backDecorations image bytes (RLE-encoded).
     */
    function backDecorations(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(backDecorationsTrait, index);
    }

    /**
     * @notice Get a backgroundDecorations image bytes (RLE-encoded).
     */
    function backgroundDecorations(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(backgroundDecorationsTrait, index);
    }

    /**
     * @notice Get a hairs image bytes (RLE-encoded).
     */
    function hairs(uint256 index) public view override returns (bytes memory) {
        return imageByIndex(hairsTrait, index);
    }

    /**
     * @notice Get a color palette bytes.
     */
    function palettes(uint8 paletteIndex) public view override returns (bytes memory) {
        address pointer = palettesPointers[paletteIndex];
        if (pointer == address(0)) {
            revert PaletteNotFound();
        }
        return SSTORE2.read(palettesPointers[paletteIndex]);
    }

    function _addBackground(string calldata _background) internal {
        backgrounds.push(_background);
    }

    function addPage(
        Trait storage trait,
        bytes calldata encodedCompressed,
        uint80 decompressedLength,
        uint16 imageCount
    ) internal {
        if (encodedCompressed.length == 0) {
            revert EmptyBytes();
        }
        address pointer = SSTORE2.write(encodedCompressed);
        addPage(trait, pointer, decompressedLength, imageCount);
    }

    function addPage(Trait storage trait, address pointer, uint80 decompressedLength, uint16 imageCount) internal {
        if (decompressedLength == 0) {
            revert BadDecompressedLength();
        }
        if (imageCount == 0) {
            revert BadImageCount();
        }
        trait.storagePages.push(
            NounArtStoragePage({ pointer: pointer, decompressedLength: decompressedLength, imageCount: imageCount })
        );
        trait.storedImagesCount += imageCount;
    }

    function imageByIndex(INounsArt.Trait storage trait, uint256 index) internal view returns (bytes memory) {
        (INounsArt.NounArtStoragePage storage page, uint256 indexInPage) = getPage(trait.storagePages, index);
        bytes[] memory decompressedImages = decompressAndDecode(page);
        return decompressedImages[indexInPage];
    }

    /**
     * @dev Given an image index, this function finds the storage page the image is in, and the relative index
     * inside the page, so the image can be read from storage.
     * Example: if you have 2 pages with 100 images each, and you want to get image 150, this function would return
     * the 2nd page, and the 50th index.
     * @return INounsArt.NounArtStoragePage the page containing the image at index
     * @return uint256 the index of the image in the page
     */
    function getPage(
        INounsArt.NounArtStoragePage[] storage pages,
        uint256 index
    ) internal view returns (INounsArt.NounArtStoragePage storage, uint256) {
        uint256 len = pages.length;
        uint256 pageFirstImageIndex = 0;
        for (uint256 i = 0; i < len; i++) {
            INounsArt.NounArtStoragePage storage page = pages[i];

            if (index < pageFirstImageIndex + page.imageCount) {
                return (page, index - pageFirstImageIndex);
            }

            pageFirstImageIndex += page.imageCount;
        }

        revert ImageNotFound();
    }

    function decompressAndDecode(INounsArt.NounArtStoragePage storage page) internal view returns (bytes[] memory) {
        bytes memory compressedData = SSTORE2.read(page.pointer);
        (, bytes memory decompressedData) = inflator.puff(compressedData, page.decompressedLength);
        return abi.decode(decompressedData, (bytes[]));
    }
}
