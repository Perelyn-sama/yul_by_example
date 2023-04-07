// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.17;

/// @notice Showcase the use of keccak256 for hashes.
contract Hash {
    function hash(uint256 a, uint256 b) public pure returns (bytes32) {
        assembly {
            mstore(0x00, a)
            mstore(0x20, b)
            mstore(0x00, keccak256(0x00, 0x40))
            return(0x00, 0x20)
        }
    }

    /// @notice Due to Yul structure, ABI.encode can be hashed, but encodePacked can't.
    ///         Unless, manually padded to 32 bytes before hash. See padStringTo32ByteBytes.
    function hashABIEncode(string memory s) public pure returns (bytes32) {
        assembly {
            mstore(0x00, 0x20)
            mstore(0x20, mload(s))
            mstore(0x40, mload(add(s, 0x20)))
            mstore(0x00, keccak256(0x00, 0x60))
            return(0x00, 0x20)
        }
    }

    function padStringTo32ByteBytes(string memory s) public pure returns (bytes memory) {
        bytes32 str = bytes32(bytes(s));
        bytes memory b = new bytes(32);

        for (uint8 i; i < 32;) {
            b[i] = str[i];
            unchecked { ++i; }
        }

        return b;
    }
}