# Flex-And-Bison-Simple-Parsing-Project

Specifications
You will extend calc.l and calc.y to parse programs whose syntax is defined below.
Prog à main() {Vardefs; Stmts}
Vardefs -> ε | Vardef; Vardefs
Vardef -> int Id | float Id
Stmts à ε | Stmt; Stmts
Stmt à Id = E | printID Id | printExp E
E à Integer | Float | Id | E - E | E * E
Integer à digit+
Float -> Integer . Integer | Integer”E”Integer | Float”E”Integer



Prog defines a program that contains only one function main().


Vardefs is a sequence of variable declarations. A program may or may not have variable declarations. ε
specifies empty variable declarations. Each variable Id is either a positive integer (int Id) or a positive floating
point (float Id).
• A positive integer is a sequence of digits from 0 to 9, e.g. 2, 96.
• A positive floating point number is a decimal point (e.g. 2.16), or an integer/decimal point followed
by an optional integer exponent part (e.g., 1.5E2). The character 'E' separates the mantissa and exponent
parts. E.g. 1.5E2 (1.5*102) and 2E5 (2*105) are valid floating points.


Stmts is a sequence of statements. A program may or may not have statements. ε specifies empty statement.
Id is an identifier, which starts with a lower-case letter and followed by 0 or more lower-case letters, capital
letters, or digits. For example, x, x1, xy, xY, x12Z are identifiers, but 1x and A1 are not. int Id defines an
integer variable. A new integer variable gets 0 as its initial value. float Id defines a floating point variable.
A new floating point variable gets 0.0 as its initial value.


Expression E is a floating point, an identifier, or an infix arithmetic expression with operators "-" (subtraction)
and “*” (multiplication) only. These two operators are left associative (e.g., 1 - 2 - 3 is equivalent to (1
- 2) - 3). * has higher precedence than -.


Id = E assigns the value of an expression E to the variable Id. printID Id prints the value of Id. printExp E
prints the value of an expression E.


If an input does not match any token, output “lexical error: <input>”, where <input> is the input.


If there is an syntax error, you are expected to interpret the program until the statement where you find the
error. Also, your error message must contain the line number where the error was found.
Tokens may be separated by any number of white spaces, tabs, or new lines.


Type checking rules are given below:
Vardef -> int Id | {Id.type = INT}
float Id {Id.type = FLOAT}
Stmt à Id = E {if (Id.type \= E.type) then type error}
E à Integer | {E.type = INT}
Float | {E.type = FLOAT}
Id | {E.type = Id.type}
E1 - E2| {if (E1.type==E2.type) then E.type = E1.type; else type error}
E1 * E2 | {if (E1.type==E2.type) then E.type = E1.type; else type error}


If one of the rules is violated, your program should terminate and print “<line number>: type error”. In
addition, if a variable is used but is not declared, then your program should print “<line number>: <variable
name> is used but is not declared”.
