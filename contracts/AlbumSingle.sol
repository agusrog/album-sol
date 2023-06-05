// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract AnimAlbum is ERC1155, Ownable {

    uint8 constant YAGUARETE = 1;
    uint8 constant PINGUINO = 2;
    uint8 constant PUMA = 3;
    uint8 constant GUANACO = 4;
    uint8 constant DECIMAL = 3;
    mapping(address => uint256) lastUpdated;


    constructor() ERC1155("https://ipfs.io/ipfs/agus/") {
        _mint(owner(), YAGUARETE, 10**DECIMAL, "");
        _mint(owner(), PINGUINO, 10**DECIMAL, "");
        _mint(owner(), PUMA, 10**DECIMAL, "");
        _mint(owner(), GUANACO, 10**DECIMAL, "");
    }

    function uri(uint256 _tokenid) override public pure returns (string memory) {
        return string(abi.encodePacked("https://ipfs.io/ipfs/agus/", Strings.toString(_tokenid),".json"));
    }

    function claim() external {
        require(msg.sender != owner(), "You are the owner");
        if (lastUpdated[msg.sender] != 0) {
            require(lastUpdated[msg.sender] < block.timestamp - 1 days, "Only one claim per day");
        }
        lastUpdated[msg.sender] = block.timestamp;
        _safeTransferFrom(owner(), msg.sender, randomNum(), 1, "");
     }

     function randomNum() private view returns (uint256)  {
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % 4 + 1;
     }
}
