// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract CalledContract {
    uint256 public number;

    function setNumber(uint256 num) external {
        assembly {
            sstore(0, num)
        }
    }

    function getNumber() public view returns (uint256) {
        assembly {
            mstore(0x00, sload(0))
            return(0x00, 0x20)
        }
    }
}

contract CallerContract {
    address public called;

    // Deploy with address of CalledContract.
    constructor(address _address) {
        assembly {
            sstore(0, _address)
        }
    }

    function callContract(uint256 num) public {
        address _called = called;

        assembly {
            mstore(0x00, 0x3fb5c1cb) // Start at 0x1c, this is the first calldata entry.
            mstore(0x20, num)

            // To learn about calldata encoding: https://rb.gy/vmzhck.
            // Read 32 + 4 bytes.
            let success := call(gas(), _called, 0, 0x1c, 0x24, 0, 0)

            if iszero(success) { revert(0x00, 0x00) }
            // In Called.sol, number == num.
        }
    }
}
