# Signature Verification

---

Source: [Verifying Signature](https://solidity-by-example.org/signature/), [solidity-by-example.org](https://solidity-by-example.org) [[7](https://solidity-by-example.org/signature/)].

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function splitSignature(bytes memory signature) public pure returns (
        bytes32 r,
        bytes32 s,
        uint8 v
    ) {
        // Signatures are 65 bytes in length. r => 32, s => 32, v => 1.
        // Although some signatures can be packed into 64 bytes.
        if (signature.length != 65) revert();

        assembly {
            r := mload(add(signature, 0x20))
            s := mload(add(signature, 0x40))
            v := byte(0, mload(add(signature, 0x60)))
        }
    }

    function verifySignature(
        address signer,
        bytes32 hash,
        bytes memory sig
    ) public pure returns (bool) {
        (bytes32 r, bytes32 s, uint8 v) = splitSignature(sig);
        address recovered = ecrecover(hash, v, r, s);

        return (recovered != address(0) && recovered == signer);
    }
}
```

`byte(a, b)` retrieves a single byte at position `a` in a 32-byte memory word, `b`. In our case, we are simply saying "Return the first byte in the 32-byte location at `add(signature, 0x60)`."

`ecrecover(a, b, c, d)` returns the address of a signer when given four arguments, `a`, the hash that was signed and `b`, `c`, `d` being the `v`, `r` and `s` components of the signature, respectively.