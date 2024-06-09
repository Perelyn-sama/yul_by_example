# Starting Yul In A Solidity Contract

---

Yul, as you know by now, is written inside Solidity functions. To start off a Yul code in a Solidity function, you simply declare the `assembly` keyword, followed by curly braces. Your Yul (Inline Assembly) code can then come inside the curly braces.

```solidity
assembly {
    // You can now write Yul here.
}
```

In a proper Solidity function, using the above, you'd have something like this.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function yulFunction() public {
        assembly {
            // Yul code here.
        }
    }
}
```

You can have more than one `assembly` block in a function.

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function yulFunctions() public {
        assembly {
            // Yul code here.
        }

        assembly {
            // Another Yul code here.
        }
    }
}
```

Variables in Yul are declared with `let` keyword. A delcared variable that has not been initialized (`y` below) defaults to 0, `0x0000000000000000000000000000000000000000000000000000000000000000` in bytes32 until it is assigned a value. They are assigned using the `:=` operator. Most importantly, there are no semicolons in Yul code. Whew!

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function yulFunction() public {
        assembly {
            let x := 5
            let y // Defaults to 0.
            y := 10
        }
    }
}
```

> 🚨 Yul does not recognize Solidity global or state variables, it only recognized local variables within functions, function parameters and named `return` variables.