# Functions

Yul can have functions in them, and these functions can return values as well.

#### A Simple Sum Function Without Return Value
This function will take two numbers, add them, and then store the sum in location `0x00`.
```assembly
assembly {
    function sum(num1, num2) {
        mstore(0x00, add(num1, num2))
    }
    sum(a, b)
}
```

#### A Simple Sum Function With Return Value
This function will take two numbers, add them, return the value as `total` and then store it in location `0x00`.
```assembly
assembly {
    function sum(num1, num2) -> total {
        total := add(num1, num2)
    }
    mstore(0x00, sum(a, b))
}
```

`PS`: **BEWARE OF OVER AND UNDERFLOWS!!!**