% GrammarFile for language PUTE

Nonterminals expr.
Terminals ':' atom integer float.
Rootsymbol expr.

% Operators
Right 100 ':'.

% Grammar
expr ->
    atom ':' expr : {assign, '$1', '$3'}.
expr ->
    integer : '$1'.
expr ->
    float : '$1'.
    
