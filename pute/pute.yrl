% GrammarFile for language PUTE

Nonterminals expr.
Terminals ':' atom integer.
Rootsymbol expr.

% Operators
Right 100 ':'.

% Grammar
expr ->
    atom ':' integer : {assign, '$1', '$3'}.
