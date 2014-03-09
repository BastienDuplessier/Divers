% Pute Realistic and Outrageous Unique Translator
-module(prout).
-export([parse/1]).

-include_lib("eunit/include/eunit.hrl").


parse(String) ->
    {_,ScanRes,_} = erl_scan:string(String),
    pute:parse(ScanRes).


assign_test() ->
    {ok,{assign,{atom,1,a},{integer,1,1}}} = parse("a : 1").
