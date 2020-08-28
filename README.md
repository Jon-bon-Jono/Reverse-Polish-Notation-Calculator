# Reverse-Polish-Notation-Calculator
Implementation of a reverse polish notation calculator using a variety of monadic functions in haskell.
[Reverse polish notation](https://en.wikipedia.org/wiki/Reverse_Polish_notation) is a way of representing arithmetic expressions, where each operator appears after the operands it works on. The calculator pushes numbers onto a stack (of type Calc) and evaluates an operator @ by popping two numbers x and y, and pushing (@ x y) back onto the stack. In the end, the number left at the top of the stack is the result of the expression.
