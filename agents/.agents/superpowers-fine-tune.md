# Overruling superpowers "writing-plans" skill

Exceptions that apply whenever planing with superpowers skill:

* In-repo spec rules and directives win; use superpowers guidance where it does not conflict; Use delegation framework last, where it does not conflict with either.
* Code blocks in plans are guidance, not implementation. For new files and interfaces, state which files exist/should exist and what they export/consume, not inner implementation. Code is allowed and incouraged in planning *ONLY* where prose would make for a larger explanation then a code snippet; larger blocks become a description of the required goal and outcome.
* Exact file paths, commands, and identifiers (function names, error codes, config keys) remain mandatory — only implementation bodies shrink.
* Do not write test implementations. Write the test blocks (before/after/describe/it, etc.) including edge cases, making clear each test intent, not implementation body. Make sure the type of test is clear (unit, functional, smoke, acceptance, etc).
* When specifying or writing tests (especially funcional and acceptance tests), make an effort to test aplication feature behavior, not the implementation. A good test allows for the same feature to have exchangable implementations (and refactors) without breaking the tests.
