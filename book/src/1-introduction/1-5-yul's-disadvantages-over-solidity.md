# Yul's Disadvantage Over Solidity

As with everything without control limits, the wrong modification, setting or manipulation of the storage or memory layout has the potential of breaching the security of the smart contract, rendering it useless till eternity, or putting users' funds at risk.

For this reason, it is advised that before writing Yul, one must understand the risks involved, and also, the workings of the EVM.