# Conditionals
There are no parentheses in the if statements, and there are no elses, rather, use switch.

`0` => `False`<br>
`1` => `True`

### If
```assembly
if lt(x, 10) { res := 0 }
if gt(x, 10) { res := 1 }
```

### Switch
```assembly
switch lt(x, 79)
case 1 { isTrue := 0x01 }
default { isTrue := 0x00 }
```