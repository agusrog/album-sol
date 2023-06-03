// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./AnimAlbum.sol";

contract Kiosko {

    address owner;

    AnimAlbum animAlbum;
    constructor(AnimAlbum _animAlbum) {
        animAlbum = _animAlbum;
        owner = msg.sender;
     }

     function claim () public {
        require(msg.sender != animAlbum.owner(), "sos uno de los duenos");
        require(msg.sender != owner, "sos uno de los duenos");
        animAlbum.safeTransferFrom(animAlbum.owner(), msg.sender, 1, 1, "");
        animAlbum.safeTransferFrom(animAlbum.owner(), msg.sender, 2, 1, "");
     }
}