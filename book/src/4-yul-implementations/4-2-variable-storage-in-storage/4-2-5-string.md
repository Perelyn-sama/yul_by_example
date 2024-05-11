# `string`

`string` is first converted into its `bytes` type by converting each individual ASCII character to its hexadecimal 
value. It is then stored in the exact way `bytes` are stored.

Example, a `string` type, `"hello"` would be first converted into `0x68656c6c6f`, a concatenation of each hexadecimal value of each character, and then stored just the way 
`bytes` are stored.

To get a knowledge of what the hexadecimal values of ASCII characters are, you can look up this table at 
[RapidTables.com](https://www.rapidtables.com/code/text/ascii-table.html).

Refer to [bytes](4-2-3-bytes.md).