Android Layout XML Semantic Analyzer 
A robust Lexical and Semantic Analyzer for Android XML layout files, built using Flex (Lexer) and Bison (Parser). This tool goes beyond simple syntax checking by performing deep semantic validation on UI attributes.

------ Features
The analyzer validates XML files based on the following semantic rules:

Unique ID Enforcement: Detects and reports duplicate android:id values across the layout.

Dimension Validation: Ensures layout_width and layout_height use positive numeric values.

UI Constraints:

Validates that padding is always a positive integer.

Checks ProgressBar attributes: max must be positive, and progress cannot be negative.

Structural Integrity (Item Count): Implements a custom check that compares the actual number of child elements against a declared android:item_count attribute.

Data Type Safety: Verifies that view_type attributes contain string literals and not numeric values.

------ Tech Stack
Flex: Lexical analysis (tokenization).

Bison: Syntax and Semantic analysis (CFG implementation).

C Language: Core logic and symbol table management.

------ Getting Started
Prerequisites
Make sure you have flex, bison, and a gcc compiler installed (e.g., via Cygwin or MinGW).

Installation
Clone the repository.

Compile the project using the provided Makefile:

Bash
make
Usage
Run the analyzer on any XML layout file:

Bash
./myParser.exe test_semantic.xml
------ Sample Output
When running on an invalid XML, the analyzer provides detailed error reporting:

Plaintext
SFALMA (b):  width must be positive!
SFALMA (c):  padding must be positive (found: -5)
SFALMA (a): To ID 'prog1'is being used!
SFALMA (3o Skelos): 2 clues found, but  item_count declared 5!

 Troubleshooting

------ Syntax Errors
If the analyzer reports a `Syntax Error`, it is usually due to:
* **Hidden characters**: Ensure the XML file does not contain special characters or unusual whitespace between tags.
* **Unclosed Tags**: Verify that every opening tag (e.g., `<LinearLayout>`) has a corresponding closing tag (e.g., `</LinearLayout>`).

------ Compilation Issues
If `make` fails, ensure that:
1. `flex` and `bison` are installed and added to your system's PATH.
2. You are using a C compiler (like `gcc`) compatible with your environment (Cygwin/MinGW).

------ Common Semantic Warnings
* **"x elements found..."**: This is a custom semantic warning indicating a mismatch between the `android:item_count` attribute and the actual child elements found in the XML.
* **"Duplicate ID"**: Ensure all `android:id` values are unique. The analyzer is case-sensitive.