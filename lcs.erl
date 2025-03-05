-module(lcs).
-export([lcs/2]).

lcs(Str1, Str2) ->
    case ets:info(lcs_table) of
        undefined -> ets:new(lcs_table, [set, public, named_table]);
        _ -> ok
    end,
    lcs_memo(Str1, Str2).

lcs_memo([], _) -> [];
lcs_memo(_, []) -> [];
lcs_memo([H1 | T1] = S1, [H2 | T2] = S2) ->
    case ets:lookup(lcs_table, {S1, S2}) of
        [{_, Result}] -> Result; % If cached, return it
        [] ->
            Result = 
                if H1 == H2 ->
                    [H1 | lcs_memo(T1, T2)];
                true ->
                    R1 = lcs_memo(T1, S2),
                    R2 = lcs_memo(S1, T2),
                    if length(R1) >= length(R2) -> R1; true -> R2 end
                end,
            ets:insert(lcs_table, {{S1, S2}, Result}),
            Result
    end.

