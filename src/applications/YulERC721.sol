// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {IERC721} from "./IERC721.sol";

// Max Supply: (2 ** 256) - 1.
bytes32 constant MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
// keccak256(Transfer(address,address,uint256))
bytes32 constant TRANSFER_EVENT = 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
// keccak256(Approval(address,address,uint256))
bytes32 constant APPROVAL_EVENT = 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;
// keccak256(ApprovalForAll(address,address,bool))
bytes32 constant APPROVAL_FOR_ALL_EVENT = 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31;

// keccak256(InexistentNFT())
bytes4 constant INEXISTENT_NFT_ERROR_SELECTOR = 0xb80613e5;
// keccak256(NotOwner())
bytes4 constant NOT_OWNER_SELECTOR = 0x30cd7471;
// keccak256(ZeroAddress())
bytes4 constant ZERO_ADDRESS_ERROR_SELECTOR = 0xd92e233d;
// keccak256(MaxSupplyReached())
bytes4 constant MAX_SUPPLY_ERROR_SELECTOR = 0xd05cb609;
// keccak256(Underflow())
bytes4 constant UNDERFLOW_ERROR_SELECTOR = 0xcaccb6d9;

/**
* @title YulERC721.
* @dev  YulERC721, ERC721, but entirely Yul.
*       Name: YulERC721, 0x59756c455243373231, 0x08
*       Symbol: $YERC, 0x2459455243, 0x05
* @notice It's a challenge to avoid one line of solidity inside functions.
*/

abstract contract YulERC721 is IERC721 {
    address private owner;

    mapping(uint256 => address) public owners;
    mapping(address => uint256) public balances;
    mapping(address => mapping(uint256 => address)) public approvals;
    mapping(address => mapping(address => bool)) public isApprovedForAll;

    constructor() {
        assembly {
            sstore(0x00, caller())
        }
    }

    fallback() external {
        assembly {
            let selector := shr(
                mul(0x1c, 8),
                calldataload(0)
            )

            function balanceOf(addr) -> bal {
                mstore(0x00, addr)
                mstore(0x20, 0x02)

                let location := keccak256(0x00, 0x40)

                mstore(0x00, sload(location))
                bal := mload(0x00)
            }

            function ownerOf(id) -> addr {
                mstore(0x00, id)
                mstore(0x20, 0x01)

                let location := keccak256(0x00, 0x40)

                mstore(0x00, sload(location))
                addr := mload(0x00)
            }

            switch selector
            // keccak256(name())
            case 0x06fdde03 {
                mstore(0x00, 0x20)
                mstore(0x29, 0x0959756c455243373231)
                return(0x00, 0x60)
            }

            // keccak256(symbol())
            case 0x95d89b41 {
                mstore(0x00, 0x20)
                mstore(0x25, 0x052459455243)
                return(0x00, 0x60)
            }

            // keccak256(balanceOf(address))
            case 0x70a08231 {
                mstore(0x00, balanceOf(calldataload(0x04)))
                return(0x00, 0x20)
            }

            // keccak256(ownerOf(uint256))
            case 0x6352211e {
                mstore(0x00, ownerOf(calldataload(0x04)))
                return(0x00, 0x20)
            }
        }
    }
}