# SelfDoc

Simple natural-looking programming language

## Operations

List of arguments can be separated by either `and` or `;` (to avoid collision with `,` being used as decimal separator in many European countries) or any combination of those. Here, the argument lists will be represented by `...` for simplicity.

| Symbol | Description |
| --- | --- |
| `...` | list of arguments |
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

// let y be x over sum of 1; 2; 3; 4 and 5
double y = x / (1 + 2 + 3 + 4 + 5);

// print x and y
printf("x = %f; y = %f\n", x, y);

// Output: x = 144; y = 9.6
```

## Notes

- Statements `sum of ...` and `product of ...` are meant to be primarily used as top-level expressions due to their prefix notation. The other operations with infix notation are primarily meant to be used in nested and/or simple expressions.
- Behavior of statements like `sum of ... and product of ...` is undefined and may change with further development. As of writing this README, the nested `product of ...` expression would be basically ignored as if the `product of` part was not there.
- To exit the interpreter, simply leave the query empty and press the Enter key.
