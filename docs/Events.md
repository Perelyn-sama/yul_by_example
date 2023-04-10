# Events

Events are emitted through the `log()` opcode which can allow up to `4` indexed events (for `anonymous events`) and `3` indexed events (for `non-anonymous events`). They range from `log0` to `log4` with each having a default `offset` and `size` as their first two parameters. This `offset` and `size` is the start and size of the `ABI encoded data` of the event's `unindexed` arguments. If there are no `unindexed` values, then `0x00` is stored for both `offset` and `size`.

Refer to https://rb.gy/bf8b1.

If the event is a `non-anonymous event`, the first topic, `topic[0]` is the `event signature`, then the subsequent topics, `topic[1]` - `topic[3]` are the indexed values of that event.

If the event is an `anonymous event`, there is no `event signature` stored, just the indexed event values.