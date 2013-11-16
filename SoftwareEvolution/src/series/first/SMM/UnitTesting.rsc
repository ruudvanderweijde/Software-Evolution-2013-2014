module series::first::SMM::UnitTesting

import IO;
import Set;
import Relation;

import series::first::SMM;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

@doc { This method is based on the paper "Static Estimation of Test Coverage" by Tiago Alves and Joost Visser
Please not that we do not include static method analysis.
}
public int getScoreOfUnitTesting(loc project) {
	logMessage("Calculating unittest coverage...", 1);
	int coverageScore = getCoverage(project);
	// result is printed below
	return coverageScore;
}

public int getCoverage(loc project) {
	M3 projectAST = createM3FromEclipseProject(project);
	set[loc] allMethods = methods(projectAST);
	
	// who calls who? include the method overrides
	rel[loc,loc] allMethodRelations = projectAST@methodInvocation + invert(projectAST@methodOverrides);
	//iprintln(allMethodRelations);

	// exlude these methods
	set[loc] startOfTestMethods = { from | <from,_> <- allMethodRelations, /Test/ := from.path, isMethod(from) };
	// Get all methods invoked by /test/ or /Test/ 
	set[loc] startMethods = { to | <from,to:_> <- allMethodRelations, /Test/ := from.path};
	// recursively get all 'next' methods
	set[loc] allInvokedMethods = nextMethods(startMethods, allMethodRelations);
	
	// all methods excluding 'start' of test methods
	num numberOfMethods = size(allMethods - startOfTestMethods);
	// & = intersection (the 'slice' function)
	num invokedMethods = size(allInvokedMethods & allMethods);
	
	// get the score
	num percentage = getPercentage(numberOfMethods, invokedMethods);
	int score = getScore(percentage);
	logMessage("-- Result: <invokedMethods>/<numberOfMethods> (<percentage>%) methods invoked. Score: <score>.", 1);	
	return score;
}

public M3 expandRelationsForDynamicDispatch(M3 projectAST) {
	//rel[loc,loc] dynamicClasses = { <x,y> | <x,y> <- declaredTopTypes(projectAST), x.file != y.file + ".java"};
	rel[loc,loc] overrides = projectAST@methodOverrides;
	
	//projectAST@
	return projectAST;
}

public set[loc] nextMethods(set[loc] methods, rel[loc,loc] allMethodRelations) {
	set[loc] nxtMethods = range(domainR(allMethodRelations, methods));
	set[loc] allNextMethods = methods + nxtMethods;
	if (allNextMethods == methods) {
		return allNextMethods;
	} else {
		return allNextMethods + nextMethods(allNextMethods, allMethodRelations);
	}
}

public num getPercentage(num allMethods, num invokedTestMethods) {
	return (invokedTestMethods / allMethods) * 100;
}

public int getScore(num percentage) {
	if 		(percentage >= 95) return 5;
	else if (percentage >= 80) return 4;
	else if (percentage >= 60) return 3;
	else if (percentage >= 20) return 2;
	else 					   return 1;
}

public void getNumberOfAsserts(loc project) {
	M3 projectAST = createM3FromEclipseProject(project);
	int cnt = 0;
	for (methodLoc <- methods(projectAST)) { 
		//assertsPerMethod(methodLoc, projectAST);
		cnt = assertsPerMethod(methodLoc, projectAST);
		if (cnt > 0) {
			println("# of asserts <cnt> in file: <methodLoc>");
		}
		//println("<assertsPerMethod(methodLoc, projectAST)>");
	}
	
}


public int assertsPerMethod(loc methodName, M3 myModel) {
	int numberOfAsserts = 0; 
	methodAST = getMethodASTEclipse(methodName, model = myModel);
	visit(methodAST) {
		case x:\assert(_)		: numberOfAsserts += 1;
    	case x:\assert(_, _)	: numberOfAsserts += 1;
	}
	return numberOfAsserts;
}
