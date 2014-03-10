% GrammarFile for language PUTE

Nonterminals expr minus.
Terminals ':' '+' '-' '*' atom integer float.
Rootsymbol expr.

% Operators
Right 100 ':'.
Left 200 '+' '-'.
Left 400 '*'.

% Grammar
expr ->
    atom ':' expr : {assign, '$1', '$3'}.
expr ->
    expr '+' expr : {add, '$1', '$3'}.
expr ->
    minus : '$1'.
expr ->
    expr minus : {add, '$1', '$2'}.
expr ->
    expr '*' expr : {mult, '$1', '$3'}.

minus ->
    '-' expr : {sub, 0, '$2'}.

expr ->
    atom : '$1'.
expr ->
    integer : '$1'.
expr ->
    float : '$1'.
    
