module demo::basic::Patterns

import IO;

//if (str S := "abc") println("Match succeeds, S == \"<S>\"");

//if([10, N*, 50] := [10, 20, 30, 40, 50]) println("Match succeeds, N == <N>");
//if([10, list[int] N, 50] := [10, 20, 30, 40, 50]) println("Match succeeds, N == <N>");

//Sets:
//if({10, S*, 50} := {50, 40, 30, 30, 10}) println("Match succeeds, S == <S>");
//if({10, set[int] S, 50} := {50, 40, 30, 30, 10}) println("Match succeeds, S == <S>");

// Variables:
//rascal>N = 10;
//int: 10
//rascal>N := 10;
//bool: true
//rascal>N := 20;
//bool: false

//for([L1*, int N, L2*, N, L3*] := [ 5, 10, 20, 30, 40, 30, 15, 20, 10]) println("L1 = <L1> and N = <N> and L2 = <L2> and L3 = <L3>");
//L1 = [5] and N = 10 and L2 = [20,30,40,30,15,20] and L3 = []
//L1 = [5,10] and N = 20 and L2 = [30,40,30,15] and L3 = [10]
//L1 = [5,10,20] and N = 30 and L2 = [40] and L3 = [15,20,10]
//list[void]: []

data Color = red(int N) | black(int N);

//if(red(K) := red(13)) println("K = <K>");


data ColoredTree = leaf(int N)
    | red(ColoredTree left, ColoredTree right) 
	| black(ColoredTree left, ColoredTree right);

//T = red(red(black(leaf(1), leaf(2)), black(leaf(3), leaf(4))), black(leaf(5), leaf(4)));