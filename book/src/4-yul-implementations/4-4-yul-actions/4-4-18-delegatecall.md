# `delegatecall`

---

`delegatecall(a, b, d, e, f, g)` functions exactly the way `staticcall()` functions in Solidity. It takes the same arguments `call` takes except the `msg.value`.

It is called exactly the same way [`staticcall`](4-4-17-staticcall.md) is called, with the same arguments, and returns the same value as well.