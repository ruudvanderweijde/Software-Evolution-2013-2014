module series::first::SMM::UnitTesting

import IO;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

public int getScoreOfUnitTesting(loc project) {
	return 0;
}

public void getCoverage(loc project) {

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
