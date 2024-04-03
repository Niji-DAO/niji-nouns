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
// This file is a modified version of nounsDAO's NounsDescriptor.sol:
// https://github.com/nounsDAO/nouns-monorepo/blob/854b9b64770401da71503972c65c4f9eda060ba6/packages/nouns-contracts/contracts/NounsDescriptor.sol
//
// NounsDescriptor.sol licensed under the GPL-3.0 license.
// With modifications by NijiNouns DAO.

import { Ownable } from '@openzeppelin/contracts/access/Ownable.sol';
import { Strings } from '@openzeppelin/contracts/utils/Strings.sol';
import { INounsDescriptor } from './interfaces/INounsDescriptor.sol';
import { INounsSeeder } from './interfaces/INounsSeeder.sol';
import { NFTDescriptor } from './libs/NFTDescriptor.sol';
import { MultiPartRLEToSVG } from './libs/MultiPartRLEToSVG.sol';

contract NounsDescriptor is INounsDescriptor, Ownable {
    using Strings for uint256;

    // prettier-ignore
    // https://creativecommons.org/publicdomain/zero/1.0/legalcode.txt
    bytes32 constant COPYRIGHT_CC0_1_0_UNIVERSAL_LICENSE = 0xa2010f343487d3f7618affe54f789f5487602331c0a8d03f49e9a7c547cf0499;

    // Whether or not new Noun parts can be added
    bool public override arePartsLocked;

    // Whether or not `tokenURI` should be returned as a data URI (Default: true)
    bool public override isDataURIEnabled = true;

    // Base URI
    string public override baseURI;

    // Noun Color Palettes (Index => Hex Colors)
    mapping(uint8 => string[]) public override palettes;

    // Noun Backgrounds (Hex Colors)
    string[] public override backgrounds;

    // Noun Specials (Custom RLE)
    bytes[] public override specials;

    // Noun Chokers (Custom RLE)
    bytes[] public override chokers;

    // Noun Headphones (Custom RLE)
    bytes[] public override headphones;

    // Noun LeftHands (Custom RLE)
    bytes[] public override leftHands;

    // Noun Hats (Custom RLE)
    bytes[] public override hats;

    // Noun Clothes (Custom RLE)
    bytes[] public override clothes;

    // Noun Ears (Custom RLE)
    bytes[] public override ears;

    // Noun Backs (Custom RLE)
    bytes[] public override backs;

    // Noun BackDecorations (Custom RLE)
    bytes[] public override backDecorations;

    // Noun BackgroundDecorations (Custom RLE)
    bytes[] public override backgroundDecorations;

    // Noun Hairs (Custom RLE)
    bytes[] public override hairs;

    /**
     * @notice Require that the parts have not been locked.
     */
    modifier whenPartsNotLocked() {
        require(!arePartsLocked, 'Parts are locked');
        _;
    }

    /**
     * @notice Get the number of available Noun `backgrounds`.
     */
    function backgroundCount() external view override returns (uint256) {
        return backgrounds.length;
    }

    /**
     * @notice Get the number of available Noun `specials`.
     */
    function specialCount() external view override returns (uint256) {
        return specials.length;
    }

    /**
     * @notice Get the number of available Noun `chokers`.
     */
    function chokerCount() external view override returns (uint256) {
        return chokers.length;
    }

    /**
     * @notice Get the number of available Noun `headphones`.
     */
    function headphoneCount() external view override returns (uint256) {
        return headphones.length;
    }

    /**
     * @notice Get the number of available Noun `leftHands`.
     */
    function leftHandCount() external view override returns (uint256) {
        return leftHands.length;
    }

    /**
     * @notice Get the number of available Noun `hats`.
     */
    function hatCount() external view override returns (uint256) {
        return hats.length;
    }

    /**
     * @notice Get the number of available Noun `clothes`.
     */
    function clotheCount() external view override returns (uint256) {
        return clothes.length;
    }

    /**
     * @notice Get the number of available Noun `ears`.
     */
    function earCount() external view override returns (uint256) {
        return ears.length;
    }

    /**
     * @notice Get the number of available Noun `backs`.
     */
    function backCount() external view override returns (uint256) {
        return backs.length;
    }

    /**
     * @notice Get the number of available Noun `backDecorations`.
     */
    function backDecorationCount() external view override returns (uint256) {
        return backDecorations.length;
    }

    /**
     * @notice Get the number of available Noun `backgroundDecorations`.
     */
    function backgroundDecorationCount() external view override returns (uint256) {
        return backgroundDecorations.length;
    }

    /**
     * @notice Get the number of available Noun `hairs`.
     */
    function hairCount() external view override returns (uint256) {
        return hairs.length;
    }

    /**
     * @notice Add colors to a color palette.
     * @dev This function can only be called by the owner.
     */
    function addManyColorsToPalette(uint8 paletteIndex, string[] calldata newColors) external override onlyOwner {
        require(palettes[paletteIndex].length + newColors.length <= 256, 'Palettes can only hold 256 colors');
        for (uint256 i = 0; i < newColors.length; i++) {
            _addColorToPalette(paletteIndex, newColors[i]);
        }
    }

    /**
     * @notice Batch add Noun backgrounds.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyBackgrounds(string[] calldata _backgrounds) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _backgrounds.length; i++) {
            _addBackground(_backgrounds[i]);
        }
    }

    /**
     * @notice Batch add Noun specials.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManySpecials(bytes[] calldata _specials) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _specials.length; i++) {
            _addSpecial(_specials[i]);
        }
    }

    /**
     * @notice Batch add Noun chokers.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyChokers(bytes[] calldata _chokers) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _chokers.length; i++) {
            _addChoker(_chokers[i]);
        }
    }

    /**
     * @notice Batch add Noun headphones.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyHeadphones(bytes[] calldata _headphones) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _headphones.length; i++) {
            _addHeadphone(_headphones[i]);
        }
    }

    /**
     * @notice Batch add Noun leftHands.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyLeftHands(bytes[] calldata _leftHands) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _leftHands.length; i++) {
            _addLeftHand(_leftHands[i]);
        }
    }

    /**
     * @notice Batch add Noun hats.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyHats(bytes[] calldata _hats) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _hats.length; i++) {
            _addHat(_hats[i]);
        }
    }

    /**
     * @notice Batch add Noun clothes.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyClothes(bytes[] calldata _clothes) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _clothes.length; i++) {
            _addClothe(_clothes[i]);
        }
    }

    /**
     * @notice Batch add Noun ears.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyEars(bytes[] calldata _ears) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _ears.length; i++) {
            _addEar(_ears[i]);
        }
    }

    /**
     * @notice Batch add Noun backs.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyBacks(bytes[] calldata _backs) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _backs.length; i++) {
            _addBack(_backs[i]);
        }
    }

    /**
     * @notice Batch add Noun backDecorations.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyBackDecorations(bytes[] calldata _backDecorations) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _backDecorations.length; i++) {
            _addBackDecoration(_backDecorations[i]);
        }
    }

    /**
     * @notice Batch add Noun backgroundDecorations.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyBackgroundDecorations(bytes[] calldata _backgroundDecorations) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _backgroundDecorations.length; i++) {
            _addBackgroundDecoration(_backgroundDecorations[i]);
        }
    }

    /**
     * @notice Batch add Noun hairs.
     * @dev This function can only be called by the owner when not locked.
     */
    function addManyHairs(bytes[] calldata _hairs) external override onlyOwner whenPartsNotLocked {
        for (uint256 i = 0; i < _hairs.length; i++) {
            _addHair(_hairs[i]);
        }
    }

    /**
     * @notice Add a single color to a color palette.
     * @dev This function can only be called by the owner.
     */
    function addColorToPalette(uint8 _paletteIndex, string calldata _color) external override onlyOwner {
        require(palettes[_paletteIndex].length <= 255, 'Palettes can only hold 256 colors');
        _addColorToPalette(_paletteIndex, _color);
    }

    /**
     * @notice Add a Noun background.
     * @dev This function can only be called by the owner when not locked.
     */
    function addBackground(string calldata _background) external override onlyOwner whenPartsNotLocked {
        _addBackground(_background);
    }

    /**
     * @notice Add a Noun Special.
     * @dev This function can only be called by the owner when not locked.
     */
    function addSpecial(bytes calldata _special) external override onlyOwner whenPartsNotLocked {
        _addSpecial(_special);
    }

    /**
     * @notice Add a Noun Choker.
     * @dev This function can only be called by the owner when not locked.
     */
    function addChoker(bytes calldata _choker) external override onlyOwner whenPartsNotLocked {
        _addChoker(_choker);
    }

    /**
     * @notice Add a Noun headphoneCount.
     * @dev This function can only be called by the owner when not locked.
     */
    function addHeadphone(bytes calldata _headphone) external override onlyOwner whenPartsNotLocked {
        _addHeadphone(_headphone);
    }

    /**
     * @notice Add a Noun leftHand.
     * @dev This function can only be called by the owner when not locked.
     */
    function addLeftHand(bytes calldata _leftHand) external override onlyOwner whenPartsNotLocked {
        _addLeftHand(_leftHand);
    }

    /**
     * @notice Add a Noun hat.
     * @dev This function can only be called by the owner when not locked.
     */
    function addHat(bytes calldata _hat) external override onlyOwner whenPartsNotLocked {
        _addHat(_hat);
    }

    /**
     * @notice Add a Noun clothe.
     * @dev This function can only be called by the owner when not locked.
     */
    function addClothe(bytes calldata _clothe) external override onlyOwner whenPartsNotLocked {
        _addClothe(_clothe);
    }

    /**
     * @notice Add a Noun ear.
     * @dev This function can only be called by the owner when not locked.
     */
    function addEar(bytes calldata _ear) external override onlyOwner whenPartsNotLocked {
        _addEar(_ear);
    }

    /**
     * @notice Add a Noun back.
     * @dev This function can only be called by the owner when not locked.
     */
    function addBack(bytes calldata _back) external override onlyOwner whenPartsNotLocked {
        _addBack(_back);
    }

    /**
     * @notice Add a Noun backDecoration.
     * @dev This function can only be called by the owner when not locked.
     */
    function addBackDecoration(bytes calldata _backDecoration) external override onlyOwner whenPartsNotLocked {
        _addBackDecoration(_backDecoration);
    }

    /**
     * @notice Add a Noun backgroundDecoration.
     * @dev This function can only be called by the owner when not locked.
     */
    function addBackgroundDecoration(bytes calldata _backgroundDecoration) external override onlyOwner whenPartsNotLocked {
        _addBackgroundDecoration(_backgroundDecoration);
    }

    /**
     * @notice Add a Noun hair.
     * @dev This function can only be called by the owner when not locked.
     */
    function addHair(bytes calldata _hair) external override onlyOwner whenPartsNotLocked {
        _addHair(_hair);
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
            return dataURI(tokenId, seed);
        }
        return string(abi.encodePacked(baseURI, tokenId.toString()));
    }

    /**
     * @notice Given a token ID and seed, construct a base64 encoded data URI for an official NijiNouns DAO noun.
     */
    function dataURI(uint256 tokenId, INounsSeeder.Seed memory seed) public view override returns (string memory) {
        string memory nounId = tokenId.toString();
        string memory name = string(abi.encodePacked('CNNoun ', nounId));
        string memory description = string(abi.encodePacked('CNNoun ', nounId, ' is a member of the NijiNouns DAO'));

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
        NFTDescriptor.TokenURIParams memory params = NFTDescriptor.TokenURIParams({
            name: name,
            description: description,
            parts: _getPartsForSeed(seed),
            background: backgrounds[seed.background]
        });
        return NFTDescriptor.constructTokenURI(params, palettes);
    }

    /**
     * @notice Given a seed, construct a base64 encoded SVG image.
     */
    function generateSVGImage(INounsSeeder.Seed memory seed) external view override returns (string memory) {
        MultiPartRLEToSVG.SVGParams memory params = MultiPartRLEToSVG.SVGParams({
            parts: _getPartsForSeed(seed),
            background: backgrounds[seed.background]
        });
        return NFTDescriptor.generateSVGImage(params, palettes);
    }

    /**
     * @notice Add a single color to a color palette.
     */
    function _addColorToPalette(uint8 _paletteIndex, string calldata _color) internal {
        palettes[_paletteIndex].push(_color);
    }

    /**
     * @notice Add a Noun background.
     */
    function _addBackground(string calldata _background) internal {
        backgrounds.push(_background);
    }

    /**
     * @notice Add a Noun special.
     */
    function _addSpecial(bytes calldata _special) internal {
        specials.push(_special);
    }

    /**
     * @notice Add a Noun choker.
     */
    function _addChoker(bytes calldata _choker) internal {
        chokers.push(_choker);
    }

    /**
     * @notice Add a Noun headphone.
     */
    function _addHeadphone(bytes calldata _headphone) internal {
        headphones.push(_headphone);
    }

    /**
     * @notice Add a Noun leftHand.
     */
    function _addLeftHand(bytes calldata _leftHand) internal {
        leftHands.push(_leftHand);
    }

    /**
     * @notice Add a Noun hat.
     */
    function _addHat(bytes calldata _hat) internal {
        hats.push(_hat);
    }

    /**
     * @notice Add a Noun clothe.
     */
    function _addClothe(bytes calldata _clothe) internal {
        clothes.push(_clothe);
    }

    /**
     * @notice Add a Noun ear.
     */
    function _addEar(bytes calldata _ear) internal {
        ears.push(_ear);
    }

    /**
     * @notice Add a Noun back.
     */
    function _addBack(bytes calldata _back) internal {
        backs.push(_back);
    }

    /**
     * @notice Add a Noun backDecoration.
     */
    function _addBackDecoration(bytes calldata _backDecoration) internal {
        backDecorations.push(_backDecoration);
    }

    /**
     * @notice Add a Noun backgroundDecoration.
     */
    function _addBackgroundDecoration(bytes calldata _backgroundDecoration) internal {
        backgroundDecorations.push(_backgroundDecoration);
    }

    /**
     * @notice Add a Noun hair.
     */
    function _addHair(bytes calldata _hair) internal {
        hairs.push(_hair);
    }

    /**
     * @notice Get all Noun parts for the passed `seed`.
     */
    function _getPartsForSeed(INounsSeeder.Seed memory seed) internal view returns (bytes[] memory) {
        bytes[] memory _parts = new bytes[](11);
        _parts[0] = specials[seed.special];
        _parts[1] = chokers[seed.choker];
        _parts[2] = headphones[seed.headphone];
        _parts[3] = leftHands[seed.leftHand];
        _parts[4] = hats[seed.hat];
        _parts[5] = clothes[seed.clothe];
        _parts[6] = ears[seed.ear];
        _parts[7] = backs[seed.back];
        _parts[8] = backDecorations[seed.backDecoration];
        _parts[9] = backgroundDecorations[seed.backgroundDecoration];
        _parts[10] = hairs[seed.hair];
        return _parts;
    }
}
