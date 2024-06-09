# Yul By Example 

---

```solidity
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

contract Yul {
    function yulFunction() public {
        assembly {
            mstore(0x40, "Yul By Example.")
        }
    }
}
```

## Source Code
book/src

## Book URL
🔗 https://yul-by-example.vercel.app/

## Run Book Locally
To run a copy of this book locally on your device, clone the repo and install `mdbook` via cargo (that comes with Rust). If you don't have Rust installed in your PC, you can download and setup Rust [here](https://www.rust-lang.org/).

To install `mdbook`, you can refer to [this](https://rust-lang.github.io/mdBook/guide/installation.html).

To display the book on your browser, run `mdbook serve book/ -o` from the base directory.

## Contributors ✨

<a href="https://github.com/Perelyn-sama/yul_by_example/graphs/contributors">
  <img src="https://contrib.rocks/image?repo=Perelyn-sama/yul_by_example" />
</a>