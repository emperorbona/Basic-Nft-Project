// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;
import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";


contract MoodNft is ERC721{
    error MoodNft__CantFlipMoodIfNotOwner();

    uint256 private s_tokenCounter;
    string private s_sadSvgImageUri;
    string private s_happySvgImageUri;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping (uint256 => Mood) s_tokenIdToMood;
    constructor(
        string memory sadSvgImageUri,
        string memory happySvgImageUri
    ) ERC721("Mood NFT", "MNT"){
        s_sadSvgImageUri = sadSvgImageUri;
        s_happySvgImageUri = happySvgImageUri;
        s_tokenCounter = 0;
    }

    function mintNft() public{
        _safeMint(msg.sender, s_tokenCounter);
        // Set default mood to happy
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter++;
    }

    function flipMood(uint256 tokenId) public {
        address owner = ownerOf(tokenId);
        if (!_isAuthorized(owner, msg.sender, tokenId)) {
            revert MoodNft__CantFlipMoodIfNotOwner();
        }

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }


    

    function _baseURI() internal pure override returns(string memory){
        return "data:application/json;base64;";
    }

    function tokenURI(uint256 tokenId) public view override returns(string memory){
        string memory imageURI;
        if(s_tokenIdToMood[tokenId] == Mood.HAPPY){
            imageURI = s_happySvgImageUri;
        }
        else{
            imageURI = s_sadSvgImageUri;
        }
        return string(
            abi.encodePacked(
            _baseURI(),
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            '{"name="', name(), '", "description":"An Nft that describes the owners mood.", "attrributes": [{"trait_type":"moodiness", "value" :100}] "image": "', imageURI, '"}'
                        )
                    )
                )
            )
        );
    }
}