import Html exposing (text)

type alias Env = (String -> Int)

type Exp = Add Exp Exp
         | Sub Exp Exp --Subtração
         | Mtp Exp Exp --Multiplicação
         | Div Exp Exp --Divisão
         | Equals Exp Exp --Igual?
         | Diff Exp Exp --Diferente?
         | Num Int
         | Var String

type Prog = Attr String Exp
          | Seq Prog Prog
          | If Exp Prog Prog
          | While Exp Prog

zero : Env
zero = \ask -> 0

e1 : Exp
e1 = Add (Num 9) (Num 1)

evalExp : Exp -> Env -> Int
evalExp exp env =
    case exp of
        Add exp1 exp2  -> (evalExp exp1 env) + (evalExp exp2 env)
        Sub exp1 exp2  -> (evalExp exp1 env) - (evalExp exp2 env)        
        Mtp exp1 exp2  -> (evalExp exp1 env) * (evalExp exp2 env)
        Div exp1 exp2  -> (evalExp exp1 env) // (evalExp exp2 env)
        Equals exp1 exp2  -> if (evalExp exp1 env) == (evalExp exp2 env) then 1 else 0
        Diff exp1 exp2  -> if (evalExp exp1 env) /= (evalExp exp2 env) then 1 else 0
        Num v          -> v
        Var var        -> (env var)

evalProg : Prog -> Env -> Env
evalProg s env =
    case s of
        Seq s1 s2 ->
            (evalProg s2 (evalProg s1 env))
        Attr var exp ->
            let
                val = (evalExp exp env)
            in
                \ask -> if ask==var then val else (env ask)
        If cond prog1 prog2 ->
            if (evalExp cond env) /= 0 then
                (evalProg prog1 env)
            else
                (evalProg prog2 env)
        While cond prog ->
            if (evalExp cond env) == 0 then
                env
            else
                (evalProg (While cond prog) (evalProg prog env))

lang : Prog -> Int
lang p = ((evalProg p zero) "ret")

p1 : Prog -- ((((5 + 5) - 4) * 2) / 3) = 12
p1 = (Seq
        (Attr "x" (Num 5))
        (Seq
            (Attr "ret" (Add (Var "x") (Num 5)))
            (Seq
                (Attr "ret" (Sub (Var "ret") (Num 4)))
                (Seq
                    (Attr "ret" (Mtp (Var "ret") (Num 2)))
                    (Attr "ret" (Div (Var "ret") (Num 3)))
                )
            )
        )
     )

p2 : Prog -- 1 == 2 ? 1 : 0
p2 = If (Equals (Num 1) (Num 2)) (Attr "ret" (Num 1)) ((Attr "ret" (Num 0)))

p3 : Prog -- 1 == 1 ? 1 : 0
p3 = If (Equals (Num 1) (Num 1)) (Attr "ret" (Num 1)) ((Attr "ret" (Num 0)))

p4 : Prog -- 2^5
p4 = (Seq
        (Attr "i" (Num 0))
        (Seq
            (Attr "ret" (Num 1))
            (While (Diff (Var "i") (Num 5))
                (Seq
                    (Attr "i" (Add (Var "i") (Num 1)))
                    (Attr "ret" (Mtp (Var "ret") (Num 2)))
                )
            )
        )
     )

main = text (toString (lang p4))