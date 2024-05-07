# Solidity's Storage And Memory

Solidity offers us two locations for data storage:
- Storage
- Memory

The **storage** includes data that persist on the smart contract. All your public, internal and private variables are stored in the storage location.

The **memory**, however is a temporary storage location that is assigned and cleared on every function call. It doesn't persist.

You can understand more about what the storage and memory locations entail in this article [here](https://medium.com/@ozorawachie/solidity-storage-layout-and-slots-a-comprehensive-guide-2cee71817ed8#:~:text=Solidity%20provides%20two%20types%20of,after%20the%20contract%20is%20terminated.).