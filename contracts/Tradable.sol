// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "./AnimAlbum.sol";

contract Tradable {

    AnimAlbum animAlbum;

    enum RegisterStatus {
        pending,
        completed
    }

    struct Register {
        RegisterStatus status;
        address account_1;
        address account_2;
        uint8 tokenId_1;
        uint8 tokenId_2;
    }

    Register[] registers;
    mapping(address => mapping(uint256 => RegisterStatus)) public transactions;

    constructor(AnimAlbum _animAlbum) {
        animAlbum = _animAlbum;
     }


     function claim () public {
        require(msg.sender != animAlbum.owner(), "sos uno de los duenos");
        animAlbum.safeTransferFrom(animAlbum.owner(), msg.sender, 1, 1, "");
        animAlbum.safeTransferFrom(animAlbum.owner(), msg.sender, 2, 1, "");
     }

     function test(address receivingAccount, uint8 tokenId_sended) public {
         animAlbum.safeTransferFrom(receivingAccount, msg.sender, tokenId_sended, 1, "");
     }

     function claimAfterSwap(uint256 transactionId) public {
        require(registers[transactionId].status == RegisterStatus.completed);
        require(registers[transactionId].account_1 == msg.sender || registers[transactionId].account_2 == msg.sender);
        if (msg.sender == registers[transactionId].account_1) {
            animAlbum.safeTransferFrom(registers[transactionId].account_2, msg.sender, registers[transactionId].tokenId_2, 1, "");
            animAlbum.setApprovalForAll(msg.sender, false);
        } else {
            animAlbum.safeTransferFrom(registers[transactionId].account_1, msg.sender, registers[transactionId].tokenId_1, 1, "");
            animAlbum.setApprovalForAll(msg.sender, false);
        }
     }

     function swap(address receivingAccount, uint8 tokenId_sended, uint8 tokenId_expected) public returns(string memory) {
         require(animAlbum.balanceOf(msg.sender, tokenId_sended) > 1, "You do not have this token");
         string memory message;
         bool shouldSave = true;
         for (uint i = 0; i < registers.length; i++) 
         {
             if (msg.sender == registers[i].account_1
             && receivingAccount == registers[i].account_2
             && tokenId_sended == registers[i].tokenId_1
             && tokenId_expected == registers[i].tokenId_2
             && registers[i].status == RegisterStatus.pending
             ) {
                 message = "Register already exists";
                 shouldSave = false;
                 break;
             }

             else if (msg.sender == registers[i].account_2
             && receivingAccount == registers[i].account_1
             && tokenId_sended == registers[i].tokenId_2
             && tokenId_expected == registers[i].tokenId_1
             && registers[i].status == RegisterStatus.pending
             ) {
                 registers[i].status == RegisterStatus.completed;
                 transactions[msg.sender][i] = RegisterStatus.completed;
                 transactions[receivingAccount][i] = RegisterStatus.completed;
                 animAlbum.setApprovalForAll(msg.sender, true);
                 message = "Register completed";
                 shouldSave = false;
                 break;
             }
         }
         if (shouldSave) {             
             Register memory newRegister = Register(RegisterStatus.pending, msg.sender, receivingAccount, tokenId_sended, tokenId_expected);
             registers.push(newRegister);
             transactions[msg.sender][registers.length] = RegisterStatus.pending;
            //  transactions[receivingAccount][registers.length] = RegisterStatus.pending;
            animAlbum.setApprovalForAll(msg.sender, true);
             message = "Register created";
         }

         return message;
     }
}