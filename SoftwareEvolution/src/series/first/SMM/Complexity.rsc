module series::first::SMM::Complexity

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;
import Map;
import List;
import util::Math;
import series::first::SMM;
import series::first::SMM::Volume;
import series::first::SMM::UnitSize;

str SIMPLE = "SIMPLE";
str MODERATE = "MODERATE";
str HIGH = "HIGH";
str VERY_HIGH = "VERY HIGH";

public map[str,int] initializeStmtMap() {
	return (
		"IF": 0,
		"IF_ELSE": 0,
		"CASE": 0,
		"FOR" : 0,
		"WHILE": 0,
		"SHORTCUT_IF" : 0,
		"CATCH" : 0
	);
}

public int getScoreOfComplexity(loc project) {
	logMessage("Calculating cyclomatic complexity...", 1);
	M3 projectModel = createM3FromEclipseProject(project);
	map [loc, num] methodSizeMap = getUnitSizePerMethod(project); 
	map [loc, tuple[num linesOfCode, str riskStr]] complexityMap = ();
	int methodCycComplexity = 0;
	num methodLength = 0;
	str cycCompRisk = " ";
	for (methodLoc <- methods(projectModel)) { 
		methodLength = methodSizeMap[methodLoc];
		methodCycComplexity = cyclometicComplexityPerMethod(methodLoc, projectModel);
		cycCompRisk = ccRiskMapping(methodCycComplexity);
		complexityMap += (methodLoc:<methodLength, cycCompRisk>);
	}
	//printComplexityMap(complexityMap);
	map [str, num] totalsMap = buildTotals(complexityMap);
	num totalLinesOfCode = getLinesOfJava(project);
	map [str, num] percentagesMap = calculatePercentages(totalsMap, totalLinesOfCode);
	int finalComplexityScore = getScoreFromMatrix(percentagesMap[MODERATE], percentagesMap[HIGH], percentagesMap[VERY_HIGH]);
	logMessage("-- Result: Cycl complexity score: <finalComplexityScore>. Details: <percentagesMap>", 1);
	return finalComplexityScore;
}

public int cyclometicComplexityPerMethod(loc methodName, M3 projectModel) {
	methodAST = getMethodASTEclipse(methodName, model = projectModel);
	map[str, int] stmtMap = initializeStmtMap(); 
	visit(methodAST) {
		case \if(_,_)		: stmtMap["IF"] += 1;
    	case \if(_,_,_) 	: stmtMap["IF_ELSE"] += 1;  // If else means one decision point
    	case \case(_)		: stmtMap["CASE"] += 1;
    	case \for(_,_,_)	: stmtMap["FOR"] += 1;
    	case \for(_,_,_,_)  : stmtMap["FOR"] += 1;
    	case \while(_,_)	: stmtMap["WHILE"] += 1;
    	case \catch(_,_)	: stmtMap["CATCH"] += 1;
    	 
		case \conditional(_,_,_) : stmtMap["SHORTCUT_IF"] += 1; 
		// We do not count "throws"
		// We do not count "finally", that's always executed
		// We do not count "try", that's not conditional
		// No returns - no condition
		// No do, that's executed at least once.
		// No break, no continue that's like return		
		// no case default, it doesnot have a condition.
		// no throw
	}
	//printMap(stmtMap);		
	int totalDecisionPoints = (0 | it + stmtMap[k] | k <- stmtMap ) + 1 ;
	logMessage("Total decision points for method <methodName> method is : <totalDecisionPoints>", 2);
	return totalDecisionPoints;
}


public str ccRiskMapping(int cycComplexity) {
	map[str mRiskStr, list[int] mRiskRange] ccRiskMap = ("SIMPLE":[1..11], "MODERATE":[11..21], 
									"HIGH":[21..51], "VERY HIGH":[51..100000]);
	list[str] resultList = 
			[riskStr | riskStr <- ccRiskMap, cycComplexity in ccRiskMap[riskStr]]; 
	logMessage("The risk for cc value: <cycComplexity> is: <resultList[0]>", 2);
	return resultList[0];
}
	
	
public map [str, num] buildTotals(map [loc methodName, tuple[num lines , str riskStr ] myTuple] stmtMap) {
	map [str, num] resultMap = ();
	num simpleTotal = sum([stmtMap[methodPar].lines | methodPar <- stmtMap, stmtMap[methodPar].riskStr == SIMPLE]);
	num moderateTotal = sum([stmtMap[methodPar].lines | methodPar <- stmtMap, stmtMap[methodPar].riskStr == MODERATE]);
	num highTotal = sum([stmtMap[methodPar].lines | methodPar <- stmtMap, stmtMap[methodPar].riskStr == HIGH]);
	num veryHighTotal = sum([stmtMap[methodPar].lines | methodPar <- stmtMap, stmtMap[methodPar].riskStr == VERY_HIGH]);
	resultMap += (SIMPLE:simpleTotal);
	resultMap += (MODERATE:moderateTotal);
	resultMap += (HIGH:highTotal);
	resultMap += (VERY_HIGH:veryHighTotal);
	return resultMap;	
}

map [str, num] calculatePercentages(map [str riskStr, num methodLines] totalsMap, num totalLinesOfCode) {
	return (totalsPar:(((totalsMap[totalsPar])/totalLinesOfCode)*100) | totalsPar <- totalsMap);
}

public void runTest1() {
	getScoreOfComplexity(|project://CodeAnalysisExamples|);	
}

public void runTest2() {
	getScoreOfComplexity(|project://SmallSQL|);	
}

public void runTest3() {
	getScoreOfComplexity(|project://HSQLDB|);	
}


// print functions
public void printStmtsMap(map[str, int] stmtMap) {	
	for (str s <- stmtMap) logMessage("Number of <s> statements is: <stmtMap[s]>", 2);
}

public void printComplexityMap(map[loc, tuple [num , str ]] stmtMap) {	 	
	for (loc l <- stmtMap) logMessage("For method: <l> lines of code and CC are: <stmtMap[l]>", 2);
}

