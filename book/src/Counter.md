# Counter

Study: https://rb.gy/3wj60

Yul does not have any checks for over and underflow, therefore, whenever the `inc()` is called, the function asserts that the current number is not equal to the max of uint256,
```assembly
0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff
```
And then, increments it by one.

Also, calling the `dec()` will assert that the current value is not equal to `0`, and then, decrements it by one.