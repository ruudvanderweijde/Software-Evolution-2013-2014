module series::first::SMM::CC

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;
import Map;
import List;
import series::first::SMM::UnitSize;
import series::first::SMM::Volume;


str SIMPLE = "SIMPLE";
str MODERATE = "MODERATE";
str HIGH = "HIGH";
str VERY_HIGH = "VERY HIGH";

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

public void printComplexityMap(map[loc, tuple [num , str ]] mapPar) {
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
	int totalDecisionPoints = (1 | it + stmtMap[k] | k <- stmtMap ) ;
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
	
	
public map [str, num] buildTotals(map [loc methodName, tuple[num lines , str riskStr ] myTuple] mapPar) {
	map [str, num] resultMap = ();
	num simpleTotal = sum([mapPar[methodPar].lines | methodPar <- mapPar, mapPar[methodPar].riskStr == SIMPLE]);
	num moderateTotal = sum([mapPar[methodPar].lines | methodPar <- mapPar, mapPar[methodPar].riskStr == MODERATE]);
	num highTotal = sum([mapPar[methodPar].lines | methodPar <- mapPar, mapPar[methodPar].riskStr == HIGH]);
	num veryHighTotal = sum([mapPar[methodPar].lines | methodPar <- mapPar, mapPar[methodPar].riskStr == VERY_HIGH]);
	resultMap += (SIMPLE:simpleTotal);
	resultMap += (MODERATE:moderateTotal);
	resultMap += (HIGH:highTotal);
	resultMap += (VERY_HIGH:veryHighTotal);
	return resultMap;	
}


map [str, num] calculatePercentages(map [str riskStr, num methodLines] totalsMap, num totalLinesOfCode) {
	map [str, num] percMap = ();
	percMap = (totalsPar:((totalsMap[totalsPar])/totalLinesOfCode*100) | totalsPar <- totalsMap);
	return percMap;
}


public void printStuff(loc sui) {
	myModel = createM3FromEclipseProject(sui);
	myMethods = methods(myModel);  
	map [loc, num] methodSizeMap = getUnitSizePerMethod(sui); 
	map [loc, tuple[num linesOfCode, str riskStr]] complexityMap = ();
	int methodCycComplexity = 0;
	num methodLength = 0;
	str cycCompRisk = " ";
	for (methodLoc <- myMethods) { 
		methodLength = methodSizeMap[methodLoc];
		methodCycComplexity = cyclometicComplexityPerMethod(methodLoc, myModel);
		cycCompRisk = ccRiskMapping(methodCycComplexity);
		complexityMap += (methodLoc:<methodLength, cycCompRisk>);
	}
	printComplexityMap(complexityMap);
	map [str, num] totalsMap = buildTotals(complexityMap);
	num totalLinesOfCode = getLinesOfJava(sui);
	map [str, num] percentagesMap = calculatePercentages(totalsMap, totalLinesOfCode);
	println("<percentagesMap>");
	println("Total lines of code: <totalLinesOfCode>");
	int finalComplexityScore = getScoreFromMatrix(percentagesMap[MODERATE], percentagesMap[HIGH], percentagesMap[VERY_HIGH]);
	println("Score for this project is: <finalComplexityScore>");
}


public void runTest1() {
	printStuff(|project://CodeAnalysisExamples|);	
}

public void runTest2() {
	printStuff(|project://SmallSQL|);	
}




