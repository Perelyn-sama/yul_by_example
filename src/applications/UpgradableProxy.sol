// SPDX-License-Identifier: MIT
pragma solidity 0.8.17;

contract Storage {
    uint256 public number;
    address public deployment;
}

contract Proxy is Storage {
    fallback() external {
        assembly {
            let size := calldatasize()
            calldatacopy(0x2400, 0x00, size)
            let sent := delegatecall(gas(), sload(deployment.slot), 0x2400, size, 0x00, 0x00)
            if iszero(sent) {
                revert(0x00, 0x00)
            }
        }
    }

    function changeAddress(address _deployment) public {
        deployment = _deployment;
    }
}

contract Delegated is Proxy {
    function increment() public {
        ++number;
    }

    function decrement() public {
        --number;
    }
}