# bf-jq

Implementation of [Brainfuck](https://brainfuck.org/) written in [jq](https://jqlang.github.io/jq/).

# Usage

```sh
# input for the comma (,) command is provided --rawfile input <filename>
./bf.jq examples/wc.b --rawfile input bf.jq
# to read from stdin
./bf.jq examples/wc.b --rawfile input /dev/stdin < bf.jq
```

The difference between `bf.jq` and `bf-labels.jq` is that `bf-labels.jq` precomputes positions of matching square brackets and thus is the faster implementation. They are otherwise the same.

# Examples

Example brainfuck programs can be found in the `examples` directory. These examples were taken from [brainfuck.org](https://brainfuck.org/) and are licensed under [Creative Commons Attribution-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-sa/4.0/).

# License

Distributed under the GPLv3 License. See `LICENSE` file in this repo for more information.
