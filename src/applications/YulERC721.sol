// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

import {IERC721} from "../interfaces/IERC721.sol";

// Max Supply: (2 ** 256) - 1.
bytes32 constant MAX = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
// keccak256(Transfer(address,address,uint256))
bytes32 constant TRANSFER_EVENT = 0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
// keccak256(Approval(address,address,uint256))
bytes32 constant APPROVAL_EVENT = 0x8c5be1e5ebec7d5bd14f71427d1e84f3dd0314c0f7b2291e5b200ac8c7c3b925;
// keccak256(ApprovalForAll(address,address,bool))
bytes32 constant APPROVAL_FOR_ALL_EVENT = 0x17307eab39ab6107e8899845ad3d59bd9653f200f220920489ca2b5937696c31;

// keccak256("INDEX_SLOT")
bytes32 constant INDEX_SLOT = 0x0940455f9f41124c59357ed8e7c2d5d29d43ff7353146922922955772810398a;

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
* @notice It's a challenge to avoid one line of solidity inside functions, still in progress.
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
            /// @dev Returns the location of the owners mapping key `id`.
            function getOwnersMapLoc(id) -> loc {
                mstore(0x00, id)
                mstore(0x20, 0x01)

                loc := keccak256(0x00, 0x40)
            }

            /// @dev Returns the location of the balances mapping key `owner`.
            function getBalancesMapLoc(owner) -> loc {
                mstore(0x00, owner)
                mstore(0x20, 0x02)

                loc := keccak256(0x00, 0x40)
            }


            /// @dev Returns the location of the approvals mapping keys `owner, id`.
            function getApprovalsMapLoc(owner, id) -> loc {
                mstore(0x00, owner)
                mstore(0x20, 0x03)

                let firstLoc := keccak256(0x00, 0x40)

                mstore(0x00, id)
                mstore(0x20, firstLoc)

                loc := keccak256(0x00, 0x40)
            }


            /// @dev Returns the location of the isApprovedForAll mapping keys `owner, spender`.
            function getApprovalsForAllMapLoc(owner, spender) -> loc {
                mstore(0x00, owner)
                mstore(0x20, 0x04)

                let firstLoc := keccak256(0x00, 0x40)

                mstore(0x00, spender)
                mstore(0x20, firstLoc)

                loc := keccak256(0x00, 0x40)
            }

            /// @dev Returns the balance of `addr`.
            function balanceOf(addr) -> bal {
                mstore(0x00, sload(getBalancesMapLoc(addr)))
                bal := mload(0x00)
            }

            /// @dev Returns the owner of `id`.
            function ownerOf(id) -> addr {
                let locValue := sload(getOwnersMapLoc(id))

                if iszero(locValue) {
                    mstore(0x00, INEXISTENT_NFT_ERROR_SELECTOR)
                    revert(0x00, 0x04)
                }

                addr := locValue
            }

            /// @dev ERC-721 `approve()` function.
            function approve(spender, id) {
                if iszero(eq(ownerOf(id), caller())) {
                    mstore(0x00, NOT_OWNER_SELECTOR)
                    revert(0x00, 0x04)
                }

                let appLocation := getApprovalsMapLoc(caller(), id)
                sstore(appLocation, spender)
            }

            /// @dev    ERC-721 `setApprovalForAll()` function.
            ///         `boolVal` must be set to 1 (true) or 0 - ∞ (false).
            function setApprovalForAll(spender, boolVal) {
                /// @dev Initialize a dependent, bool value.
                let val

                switch boolVal
                case 0x00 {
                    val := 0x00
                } case 0x01 {
                    val := 0x01
                }

                sstore(
                    getApprovalsForAllMapLoc(caller(), spender),
                    val
                )
            }

            function isOwnerOrApproved(from, id) -> boolVal {
                if iszero(ownerOf(id)) {
                    mstore(0x00, ZERO_ADDRESS_ERROR_SELECTOR)
                    revert(0x00, 0x04)
                }

                if or(
                    or(
                        eq(ownerOf(id), from),
                        eq(sload(getApprovalsMapLoc(ownerOf(id), id)), from)
                    ),
                    eq(sload(getApprovalsForAllMapLoc(ownerOf(id), from)), 0x01)
                ) {
                    boolVal := 0x01
                }
            }

            function transfer(from, to, id) {
                let idOwner := ownerOf(id)

                if iszero(isOwnerOrApproved(caller(), id)) {
                    mstore(0x00, NOT_OWNER_SELECTOR)
                    revert(0x00, 0x04)
                }

                if iszero(
                    eq(idOwner, from)
                ) {
                    mstore(0x00, NOT_OWNER_SELECTOR)
                    revert(0x00, 0x04)
                }

                if iszero(to) {
                    mstore(0x00, ZERO_ADDRESS_ERROR_SELECTOR)
                    revert(0x00, 0x04)
                }

                let fromBal := sload(getBalancesMapLoc(idOwner))
                let toBal := sload(getBalancesMapLoc(to))

                sstore(getOwnersMapLoc(id), to)
                sstore(getBalancesMapLoc(idOwner), sub(fromBal, 0x01))
                sstore(getBalancesMapLoc(to), add(toBal, 0x01))
            }

            let selector := shr(
                mul(0x1c, 8),
                calldataload(0)
            )

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

            // keccak256(approve(address,uint256))
            case 0x095ea7b3 {
                approve(
                    calldataload(0x04),
                    calldataload(0x24)
                )

                log4(0x00, 0x00, APPROVAL_EVENT, caller(), calldataload(0x04), calldataload(0x24))
            }

            // keccak256(setApprovalForAll(address,bool))
            case 0xa22cb465 {
                setApprovalForAll(
                    calldataload(0x04),
                    calldataload(0x24)
                )

                mstore(0x00, calldataload(0x24))
                log3(0x00, 0x20, APPROVAL_FOR_ALL_EVENT, caller(), calldataload(0x04))
            }

            // keccak256(getApproved(uint256))
            case 0x081812fc {
                mstore(0x00, sload(getApprovalsMapLoc(caller(), calldataload(0x04))))
                return(0x00, 0x20)
            }

            // keccak256(isApprovedForAll(address,address))
            case 0xe985e9c5 {
                mstore(
                    0x00,
                    sload(
                        getApprovalsForAllMapLoc(
                            calldataload(0x04),
                            calldataload(0x24)
                        )
                    )
                )
                return(0x00, 0x20)
            }

            // keccak256(mint(address))
            case 0x6a627842 {
                let id := sload(INDEX_SLOT)
                if eq(id, MAX) {
                    mstore(0x00, MAX_SUPPLY_ERROR_SELECTOR)
                    revert(0x00, 0x04)
                }

                let receiver := calldataload(0x04)
                let bal := sload(getBalancesMapLoc(receiver))
                if eq(bal, MAX) {
                    mstore(0x00, MAX_SUPPLY_ERROR_SELECTOR)
                    revert(0x00, 0x04)
                }

                sstore(getOwnersMapLoc(id), receiver)
                sstore(getBalancesMapLoc(receiver), add(bal, 0x01))
                sstore(INDEX_SLOT, add(id, 0x01))
            }

            // keccak256(burn(uint256))
            case 0x42966c68 {
                let spender := caller()
                let id := calldataload(0x04)
                let idOwner := ownerOf(id)
                let index := sload(INDEX_SLOT)
                let bal := sload(getBalancesMapLoc(idOwner))

                if iszero(isOwnerOrApproved(caller(), id)) {
                    mstore(0x00, NOT_OWNER_SELECTOR)
                    revert(0x00, 0x04)
                }

                sstore(getOwnersMapLoc(id), 0x00)
                sstore(getBalancesMapLoc(idOwner), sub(bal, 0x01))
                sstore(INDEX_SLOT, sub(index, 0x01))
            }

            // keccak256(transferFrom(address,address,uint256))
            case 0x23b872dd {
                let from := calldataload(0x04)
                let to := calldataload(0x24)
                let id := calldataload(0x44)

                transfer(from, to, id)

                log4(0x00, 0x00, TRANSFER_EVENT, from, to, id)
            }

            // keccak256(safeTransferFrom(address,address,uint256))
            case 0x42842e0e {
                let from := calldataload(0x04)
                let to := calldataload(0x24)
                let id := calldataload(0x44)

                transfer(from, to, id)

                log4(0x00, 0x00, TRANSFER_EVENT, from, to, id)
            }

            // keccak256(safeTransferFrom(address,address,uint256,bytes))
            case 0xb88d4fde {
                let from := calldataload(0x04)
                let to := calldataload(0x24)
                let id := calldataload(0x44)

                let bytesLength := calldataload(0x84)
                calldatacopy(0x80, 0xa4, bytesLength)

                transfer(from, to, id)

                let sent := call(gas(), to, 0, 0x80, bytesLength, 0x00, 0x20)
                if iszero(sent) {
                    revert(0x00, 0x00)
                }

                log4(0x00, 0x00, TRANSFER_EVENT, from, to, id)
            }
        }
    }
}