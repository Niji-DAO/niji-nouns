// SPDX-License-Identifier: GPL-3.0

/// @title A library used to construct ERC721 token URIs and SVG images

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

import { Base64 } from 'base64-sol/base64.sol';
import { ISVGRenderer } from '../interfaces/ISVGRenderer.sol';
import 'hardhat/console.sol';

library NFTDescriptorV2 {
    struct TokenURIParams {
        string name;
        string description;
        string background;
        ISVGRenderer.Part[] parts;
    }

    /**
     * @notice Construct an ERC721 token URI.
     */
    function constructTokenURI(
        ISVGRenderer renderer,
        TokenURIParams memory params
    ) public view returns (string memory) {
        console.log('constructTokenURI');
        string memory image = generateSVGImage(
            renderer,
            ISVGRenderer.SVGParams({ parts: params.parts, background: params.background })
        );

        console.log('image', image);
        console.log('name', params.name);
        console.log('description', params.description);
        console.log('pack start');

        // prettier-ignore
        return string(
            abi.encodePacked(
                'data:application/json;base64,',
                Base64.encode(
                    bytes(
                        abi.encodePacked('{"name":"', params.name, '", "description":"', params.description, '", "image": "', 'data:image/svg+xml;base64,', image, '"}')
                    )
                )
            )
        );
        // prettier-ignore
        // return string(
        //     abi.encodePacked(
        //         'data:application/json;base64,',
        //         Base64.encode(
        //             bytes(
        //                 abi.encodePacked(
        //                     '{"name":"', params.name, '", "description":"', params.description, '", "image": "https://res.cloudinary.com/dplp5wtzk/niji/img', params.parts[0].image, params.parts[1].image, params.parts[2].image, params.parts[3].image, params.parts[4].image, params.parts[5].image, params.parts[6].image, params.parts[7].image, params.parts[8].image, params.parts[9].image, params.parts[10].image, '.png"}'
        //                 )
        //             )
        //         )
        //     )
        // );
    }

    /**
     * @notice Generate an SVG image for use in the ERC721 token URI.
     */
    function generateSVGImage(
        ISVGRenderer renderer,
        ISVGRenderer.SVGParams memory params
    ) public view returns (string memory svg) {
        return Base64.encode(bytes(renderer.generateSVG(params)));
    }
}
