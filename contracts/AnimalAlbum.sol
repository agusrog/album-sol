// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AnimAlbum is ERC1155, Ownable {

    uint8 constant YAGUARETE = 1;
    uint8 constant PINGUINO = 2;
    uint8 constant PUMA = 3;
    uint8 constant GUANACO = 4;
    uint8 public constant DECIMAL = 3;


    constructor() ERC1155("") {
        _mint(owner(), YAGUARETE, 10**DECIMAL, "");
        _mint(owner(), PINGUINO, 10**DECIMAL, "");
    }

    approve() public {
        _setApprovalForAll(msg.sender, true);
    }
}
