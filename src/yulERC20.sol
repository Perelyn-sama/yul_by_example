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

bytes32 constant transferHash = 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;

// @title Yul ERC20
// @author Some random Dude

contract YulERC20 {
    // 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef
    event Transfer(address indexed sender, address indexed receiver, uint256 amount);

    function name() public pure returns (string memory) {
        assembly {
            let memptr := mload(0x40)
            mstore(memptr, 0x20) // String pointer
            mstore(add(memptr, 0x20), nameLength) // String length
            mstore(add(memptr, 0x40), nameData) // String data
            return(memptr, 0x60)
        }
    }

    function symbol() public pure returns (string memory) {
        assembly {
            let memptr := mload(0x40)
            mstore(memptr, 0x20)
            mstore(add(memptr, 0x20), symbolLength)
            mstore(add(memptr, 0x20), symbolData)
            return(memptr, 0x60)
        }
    }

    function decimal() public pure returns (uint8) {
        assembly {
            mstore(0x00, 18)
            return(0x00, 0x20)
        }
    }

    function balanceOf(address) public view returns (uint256) {
        assembly {
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

    function transfer(address receiver, uint256 value) public returns (bool) {
        assembly {
            // mem stuff
            let memptr := mload(0x40)

            // load caller balance, assert sufficient
            mstore(memptr, caller())
            mstore(add(memptr, 0x20), 0x00)
            let callerBalanceSlot := keccak256(memptr, 0x40)
            let callerBalance := sload(callerBalanceSlot)

            if lt(callerBalance, value) {
                mstore(0x00, InsufficientBalanceSelector)
                revert(0x00, 0x04)
            }

            if eq(caller(), receiver) { revert(0x00, 0x00) }

            // decrease caller balance
            let newCallerBalance := sub(callerBalance, value)
            sstore(callerBalanceSlot, newCallerBalance)

            // load receiver balance
            mstore(memptr, receiver)
            mstore(add(memptr, 0x20), 0x00)

            let receiverBalanceSlot := keccak256(memptr, 0x40)
            let receiverBalance := sload(receiverBalanceSlot)

            // increase reciver balance
            let newReciverBalance := add(receiverBalance, value)

            // store
            sstore(receiverBalanceSlot, newReciverBalance)

            //log
            mstore(0x00, value)
            log3(0x00, 0x20, transferHash, caller(), receiver)

            // return
            mstore(0x00, 0x01)
            return(0x00, 0x20)
        }
    }

    // keccak256(spender, keccak256(owner, slot)))
    function allowance(address owner, address spender) public view returns (uint256) {
        assembly {
            mstore(0x00, owner)
            mstore(0x20, 0x01)
            let innerHash := keccak256(0x00, 0x20)

            mstore(0x00, spender)
            mstore(0x20, innerHash)
            let allowanceSlot := keccak256(0x00, 0x40)

            let allowanceValue := sload(allowanceSlot)
            mstore(0x00, allowanceValue)
            return(0x00, 0x20)
        }
    }
}
