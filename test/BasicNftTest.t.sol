// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BasicNft} from "src/BasicNft.sol";
import {DeployBasicNft} from "../script/DeployBasicNft.s.sol";

contract BasicNftTest is Test {
    BasicNft public basicNft;
    string public constant PUG = "ipfs://bafybeig37ioir76s7mg5oobetncojcm3c3hxasyd4rvid4jqhy4gkaheg4/?filename=0-PUG.json";
    address public USER = makeAddr("user");

    function setUp() external {
        DeployBasicNft deployer = new DeployBasicNft();
        basicNft = deployer.run(); 
    }

    function testNameIsCorrect() external view{
        string memory expectedName = "Dogie";
        string memory actualName = basicNft.name();
        assert(
            keccak256(abi.encodePacked(expectedName)) == 
            keccak256(abi.encodePacked(actualName))
            );
    }
    function testSymbolIsCorrect() external view {
        string memory expectedSymbol = "DOG";
        string memory actualSymbol = basicNft.symbol();
        assert(
            keccak256(abi.encodePacked(expectedSymbol)) == 
            keccak256(abi.encodePacked(actualSymbol))
            );
    }

    function testCanMintAndHaveABalance() external {
        vm.prank(USER);
        basicNft.mint(PUG);
        assert(basicNft.balanceOf(USER) == 1);
        assert(keccak256(abi.encodePacked(basicNft.tokenURI(0))) == 
            keccak256(abi.encodePacked(PUG)));
    }
}