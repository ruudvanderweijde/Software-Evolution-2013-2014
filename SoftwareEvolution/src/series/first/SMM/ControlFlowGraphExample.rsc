module series::first::SMM::ControlFlowGraphExample

// This program is based on the following examples of Racsal library
// rascal / src / org / rascalmpl / library / demo / McCabe.rsc
// Recipes/Languages/Pico/ControlFlow

import analysis::graphs::Graph;
import Prelude; 
import Set;
import Relation;

public data CFNode                                                                
	= entry(loc location)
	| exit()
	| choice(loc location, EXP exp)
	| statement(loc location, STATEMENT stat);
	
alias CFGraph = tuple[set[CFNode] entry, Graph[CFNode] graph, set[CFNode] exit];



CFGraph cflowStat(s:Statement) {                                
   S = statement(s@location, s);
   return <{S}, {}, {S}>;
}


// if then else
CFGraph cflowStat (\if(Expression Exp, Statement Stats1, Statement Stats2)) {
   CF1 = cflowStats(Stats1); 
   CF2 = cflowStats(Stats2); 
   E = {choice(Exp@location, Exp)}; 
   return < E, (E * CF1.entry) + (E * CF2.entry) + CF1.graph + CF2.graph, CF1.exit + CF2.exit >;
}

// if 
CFGraph cflowStat (\if(Expression Exp, Statement Stats)) {
   CF = cflowStats(Stats); 
   E = {choice(Exp@location, Exp)}; 
   return < E, (E * CF.entry) + CF.graph + (CF.exit * E), E >;
}


// \while(Expression condition, Statement body)
CFGraph cflowStat(\while(Expression Exp, Statement Stats))
 {                    
   CF = cflowStats(Stats); 
   E = {choice(Exp@location, Exp)}; 
   return < E, (E * CF.entry) + CF.graph + (CF.exit * E), E >;
}


// \do (Expression condition, Statement body)
CFGraph cflowStat(\do(Statement Stats, Expression Exp))
 {                    
   CF = cflowStats(Stats); 
   E = {choice(Exp@location, Exp)}; 
   return < E, (E * CF.entry) + CF.graph + (CF.exit * E), E >;
}

// \for (Expression condition, Statement body)
// \for(list[Expression] initializers, Expression condition, list[Expression] updaters, Statement body)
CFGraph cflowStat(\for(_, Expression Exp, _, Statement Stats))
 {                    
   CF = cflowStats(Stats); 
   E = {choice(Exp@location, Exp)}; 
   return < E, (E * CF.entry) + CF.graph + (CF.exit * E), E >;
}




CFGraph cflowStats(list[STATEMENT] Stats){                                        
  if(size(Stats) == 1)
     return cflowStat(Stats[0]);
  CF1 = cflowStat(Stats[0]);
  CF2 = cflowStats(tail(Stats));
  return < CF1.entry, CF1.graph + CF2.graph + (CF1.exit * CF2.entry), CF2.exit >;
}


public CFGraph cflowProgram(PROGRAM P){                                           
  if(program(list[DECL] Decls, list[STATEMENT] Series) := P){
     CF = cflowStats(Series);
     Entry = entry(P@location);
     Exit  = exit();
     return <{Entry}, ({Entry} * CF.entry) + CF.graph + (CF.exit * {Exit}), {Exit}>;
  } else
    throw "Cannot happen";
}

public CFGraph cflowProgram(str txt) = cflowProgram(load(txt));                   

	





public int cyclomaticComplexity(Graph[&T] CFG){
    return size(CFG) - size(carrier(CFG)) + 2;
}

Graph[int] G1 = {<1,2>, <2,3>};

Graph[int] G3 = {<1,2>, <1,3>, <2,6>, <3,4>, <3,5>, <4,7>, <5,8>, <6,7>, <7,8>};

Graph[int] G5 = {<1,2>, <2,3>, <2,4>, <3,6>, <4,2>, <4,5>, <5, 10>, <6, 7>,
                 <7, 8>, <7,9>, <8,9>, <9, 7>, <9,10>};
                 


public test bool t1() = cyclomaticComplexity(G1) == 1;
public test bool t2() = cyclomaticComplexity(G3) == 3;
public test bool t3() = cyclomaticComplexity(G5) == 5;


