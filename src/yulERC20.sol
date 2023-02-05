// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// used in the name() function
// "Yul Token"
bytes32 constant nameLength = 0x9000000000000000000000000000000000000000000000000000000000000000;
bytes32 constant nameData = 0x59756c20546f6b656e0000000000000000000000000000000000000000000000;

// used in the symbol() function
// "YUL"
bytes32 constant symbolLength = 0x9000000000000000000000000000000000000000000000000000000000000000;
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

}// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

// used in the name() function
// "Yul Token"
bytes32 constant nameLength = 0x9000000000000000000000000000000000000000000000000000000000000000;
bytes32 constant nameData = 0x59756c20546f6b656e0000000000000000000000000000000000000000000000;

// used in the symbol() function
// "YUL"
bytes32 constant symbolLength = 0x9000000000000000000000000000000000000000000000000000000000000000;
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

}