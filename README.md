# SelfDoc

Simple natural-looking programming language

## Operations

List of arguments can be separated by either `and` or `,` (support for `,` as decimal separator has been dropped for consistency) or any combination of those. Here, the argument lists will be represented by `...` for simplicity.

| Symbol   | Description             |
| -------- | ----------------------- |
| `...`    | list of arguments       |
| `X`, `Y` | placeholder expressions |

**Addition:** `sum of ...` or `X plus Y`

**Subtraction:** `X minus Y`

**Multiplication:** `product of ...` or `X times Y`

**Division:** `X over Y`

## Examples

The code consists of a SelfDoc line written in as a C language comment (to avoid breaking the syntax highlighting) followed by an equivalent statement in the C language.

```c
// let x be product of 12 and 5 plus 7
double x = 12 * (5 + 7);

// let y be x over sum of 1, 2, 3, 4 and 5
double y = x / (1 + 2 + 3 + 4 + 5);

// print y
printf("%g\n", y);

// Output: 9.6
```

## Notes

- `sum of ...` and `product of ...` expressions are meant to be primarily used as top-level expressions due to their prefix notation. The other operations with infix notation are primarily meant to be used in nested and/or simple expressions.
- Behavior of statements containing multiple `sum of ...` and/or `product of ...` expressions is undefined and may change with further development.
- `print` statement currently only supports a single expression at a time; there has been a downgrade since the initial C#.NET version.
