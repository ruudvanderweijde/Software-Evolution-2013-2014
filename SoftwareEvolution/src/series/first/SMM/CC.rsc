module series::first::SMM::CC

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;
import Map;
import List;
import series::first::SMM::UnitSize;

public map[str,int] initializeStmtMap() {
	map[str, int] mapPar = ();
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

public void printStmtsMap(map[str, int] mapPar) {
	for (str s <- [k | k <- mapPar] ) 
		{ println ("Number of <s> statements is: <mapPar[s]>"); 	
	}
}

public void printComplexityMap(map[loc, tuple [num , int ]] mapPar) {
	for (loc l <- [k | k <- mapPar] ) 
		{ println ("For method: <l> lines of code and CC are: <mapPar[l]>  "); 	
	}
}




public int cyclometicComplexityPerMethod(loc methodName, M3 myModel) {
	methodAST = getMethodASTEclipse(methodName, model = myModel);
	map[str, int] stmtMap = initializeStmtMap(); 
	visit(methodAST) {
		case \return(_) 	: stmtMap["RETURN"] +=  1;
    	case \return()		: stmtMap["RETURN"] +=  1;
    	case \if(_,_)		: stmtMap["IF"] += 1;
    	case \if(_,_,_) 	: stmtMap["IF_ELSE"] += 2;  // If else means two decision points
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
	//printMap(stmtMap);		
	int totalDecisionPoints = (0 | it + stmtMap[k] | k <- stmtMap ) ;
	println("Total decision points for method <methodName> method is : <totalDecisionPoints>");
	return totalDecisionPoints;
}


public str ccRiskMapping(int cycComplexity) {
	map[str mRiskStr, list[int] mRiskRange] ccRiskMap = ("SIMPLE":[1..11], "MODERATE":[11..21], 
									"HIGH":[21..51], "VERY HIGH":[51..100000]);
	list[str] resultList = 
			[riskStr | riskStr <- ccRiskMap, cycComplexity in ccRiskMap[riskStr]]; 
	println("The risk for cc value: <cycComplexity> is: <resultList[0]>");
	return resultList[0];
}



public void printStuff() {
	loc sui = |project://CodeAnalysisExamples|;
	myModel = createM3FromEclipseProject(|project://CodeAnalysisExamples|);
	myMethods = methods(myModel);  
	map [loc, num] methodSizeMap = getUnitSizePerMethod(sui); 
	map [loc, tuple[num linesOfCode, int cyclometicComplexity]] complexityMap = 
									();
	int methodCycComplexity = 0;
	num methodLength = 0;
	for (methodLoc <- myMethods) { 
		methodCycComplexity = cyclometicComplexityPerMethod(methodLoc, myModel);
		methodLength = methodSizeMap[methodLoc];
		complexityMap += (methodLoc:<methodLength, methodCycComplexity>);
	}
	printComplexityMap(complexityMap);
}
