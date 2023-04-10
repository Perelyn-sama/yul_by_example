# ForLoop

In Yul, there is only a `for` loop, and no `while` loop, however, we can rewrite a `for` loop to match a `while` loop.

```assembly
for { let i := 0 } lt(i, 10) { i := add(i, 1) }
```
Is the Yul way of writing:
```javascript
for (i = 0; i < 10; i++)
```

### While Loop Imitation
Source: http://rb.gy/4narf.
```assembly
assembly {
    let x := 0
    let i := 0
    for { } lt(i, 0x100) { } {   // while(i < 256), 100 (hex) = 256
        x := add(x, mload(i))
        i := add(i, 0x20)
    }
}
```