// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// used in the name() function
// "Yul Token"
bytes32 constant nameLength = 0x0000000000000000000000000000000000000000000000000000000000000009;
bytes32 constant nameData = 0x59756c20546f6b656e0000000000000000000000000000000000000000000000;

// used in the symbol() function
// "YUL"
bytes32 constant symbolLength = 0x0000000000000000000000000000000000000000000000000000000000000003;
bytes32 constant symbolData = 0x59554c0000000000000000000000000000000000000000000000000000000000;

// bytes4(keccak256("InsufficientBalance()")) 0xf4d678b8
bytes32 constant InsufficientBalanceSelector = 0xf4d678b800000000000000000000000000000000000000000000000000000000;

// bytes4(keccak256("InsufficientAllowance(address, address)")) 0xf180d8f9
bytes32 constant InsufficientAllowanceSelector = 0xf180d8f900000000000000000000000000000000000000000000000000000000;

    error InsufficientBalance();
    error InsufficientAllowance(address owner, address spender);

// @title Yul ERC20
// @author Some random Dude

contract YulERC20 {
    function name() public pure returns(string memory) {
        assembly {
            let memptr := mload(0x40)
            mstore(memptr, 0x20) // String pointer
            mstore(add(memptr, 0x20), nameLength) // String length
            mstore(add(memptr, 0x40), nameData) // String data
            return(memptr, 0x60)
        }
    }

    function symbol() public pure returns(string memory){
        assembly {
            let memptr := mload(0x40)
            mstore(memptr, 0x20)
            mstore(add(memptr, 0x20), symbolLength)
            mstore(add(memptr, 0x20), symbolData)
            return(memptr, 0x60)
        }
    }

    function decimal() public pure returns(uint8){
        assembly {
            mstore(0x00, 18)
            return(0x00, 0x20)
        }
    }

    function balanceOf(address) public view returns(uint256){
        assembly{
            // Store the calldate after 4 to 0x00
            mstore(0x00, calldataload(4))

            // Store the pointer of the calldataload(4) to 0x20
            mstore(0x20, 0x00)

            // keccak256(0x00, 0x40) hash 0x00 to 0x40 and generate a key
            // sload(keccak256(0x00, 0x40)) load what's in the key
            // mstore(0x00, sload(keccak256(0x00, 0x40))) store the value of the key in 0x00
            mstore(0x00, sload(keccak256(0x00, 0x40)))

            // Return 32 bytes from 0x00
            return(0x00, 0x20)
        }
    }

}