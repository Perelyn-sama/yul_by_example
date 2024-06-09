# Variable Storage In Storage

---

Solidity stores variables declared globally, otherwise known as state variables in storage. The storage is made up of slots, as we have discussed earlier. In this section we will look at how different data types are stored in Solidity's storage. Some are packed and some are greedy enough to take up a full slot without sharing.

You can head into the start of the section at [uint8, uint128, uint256](4-2-1-uint8-uint128-uint256.md).