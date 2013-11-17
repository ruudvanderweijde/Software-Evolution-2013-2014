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

	tuple[num totalMethods, num invokedMethods] measures = getMeasures(project);
	num percentage = getPercentage(measures.totalMethods, measures.invokedMethods);
	int score = getScore(percentage);
	logMessage("-- Result: <measures.totalMethods>/<measures.invokedMethods> (<percentage>%) methods invoked. Score: <score>.", 1);	
	return score;
}

public tuple[num, num] getMeasures(loc project) {
	M3 projectAST = createM3FromEclipseProject(project);
	set[loc] allMethods = methods(projectAST);
	
	// who calls who? include the method overrides
	rel[loc,loc] allMethodRelations = projectAST@methodInvocation + invert(projectAST@methodOverrides);
	//iprintln(allMethodRelations);

	// exlude these methods
	set[loc] startOfTestMethods = { m | m <- allMethods, /Test/ := m.path };
	
	// Get all methods invoked by /test/ or /Test/ 
	set[loc] startMethods = { to | <from,to:_> <- allMethodRelations, /Test/ := from.path};
	// recursively get all 'next' methods
	set[loc] allInvokedMethods = nextMethods(startMethods, allMethodRelations);
	
	// all methods excluding 'start' of test methods
	num numberOfMethods = size(allMethods - startOfTestMethods);
	// & = intersection (the 'slice' function)
	num invokedMethods = size(allInvokedMethods & allMethods);
	
	//iprintln(startOfTestMethods);
	//iprintln(allMethods - startOfTestMethods);
	//iprintln(allInvokedMethods & allMethods);
	
	return <numberOfMethods, invokedMethods>;
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

@Doc { Test methods, based on the paper of Alves and Visser }
private loc testProject1 = |project://UnitTest1|;
private loc testProject2 = |project://UnitTest2|;
private loc testProject3 = |project://UnitTest3|;
private loc testProject4 = |project://UnitTest4|;
private loc testProject5 = |project://UnitTest5|;

public test bool projectCoverage1() = getMeasures(testProject1) == <2,2>;
public test bool projectCoverage2() = getMeasures(testProject2) == <3,3>;
public test bool projectCoverage3() = getMeasures(testProject3) == <5,4>;
public test bool projectCoverage4() = getMeasures(testProject4) == <6,4>;
public test bool projectCoverage5() = getMeasures(testProject5) == <3,3>; /* fails because statis analysis is not covered yet */