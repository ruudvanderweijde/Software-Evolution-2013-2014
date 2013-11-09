module series::first::SMM::CC

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;
import Map;

public map[str,int] initializeStmtMap() {
	map[str, int] mapPar = ("" : 0);
	mapPar += ("RETURN": 0);
	mapPar += ("IF": 0);
	mapPar += ("IF_ELSE": 0);	
	mapPar += ("CASE": 0);	
	mapPar += ("CASE_DEFAULT":0);	
	mapPar += ("FOR" : 0);	
	mapPar += ("WHILE": 0);	
	mapPar += ("DO" : 0);
	mapPar += ("BREAK" : 0);	
	mapPar += ("CONTINUE" : 0);
	mapPar += ("SHORTCUT_IF" : 0); 
	mapPar += ("CATCH" : 0);
	mapPar += ("FINALLY" : 0);
	mapPar += ("THROW" : 0);		
	mapPar += ("THROWS": 0);
	return mapPar; 
}

public void printMap(map[str, int] mapPar) {
//[k | k <- m ] gives a list of keys and
//[ m[k] | K <- m ] gives a list of values. 
	for (str s <- [k | k <- mapPar] ) 
		{ println ("Number of <s> statements is: <mapPar[s]>"); 	
	}
}

public int cyclometicComplexityPerMethod(loc methodName, M3 myModel) {
	methodAST = getMethodASTEclipse(methodName, model = myModel);
	map[str, int] stmtMap = initializeStmtMap(); 
	visit(methodAST) {
		case \return(_) 	: stmtMap["RETURN"] +=  1;
    	case \return()		: stmtMap["RETURN"] +=  1;
    	case \if(_,_)		: stmtMap["IF"] += 1;
    	case \if(_,_,_) 	: stmtMap["IF_ELSE"] += 1;
    	case \case(_)		: stmtMap["CASE"] += 1;
    	case \defaultCase() : stmtMap["CASE_DEFAULT"] += 1;
    	case \for(_,_,_)	: stmtMap["FOR"] += 1;
    	case \for(_,_,_,_)  : stmtMap["FOR"] += 1;
    	case \while(_,_)	: stmtMap["WHILE"] += 1;
    	case \do(_,_)		: stmtMap["DO"] += 1;
    	case \break()		: stmtMap["BREAK"] += 1;
    	case \break(_)		: stmtMap["BREAK"] += 1;
    	case \continue()	: stmtMap["CONTINUE"] += 1;
    	case \continue(_)	: stmtMap["CONTINUE"] += 1;
    	case \catch(_,_)	: stmtMap["CATCH"] += 1;
    	case \try(_,_,_)	: stmtMap["FINALLY"] += 1;
    	case \throw(_)		: stmtMap["THROW"] += 1;
    	 
		case \conditional(_,_,_) : stmtMap["SHORTCUT_IF"] += 1; 
		// What do we do with the "THROWS"? 
	}
	printMap(stmtMap);		
}


public void printStuff() {
	myModel = createM3FromEclipseProject(|project://CodeAnalysisExamples|);
	cyclometicComplexityPerMethod(|java+method:///MyHelloWorld/a()|, myModel);
}
