module series::first::SMM
/* SMM: Sig Maintanability Model */

import IO;
import List;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import series::first::SMM::Volume;
import series::first::SMM::Complexity;
import series::first::SMM::Duplication;
import series::first::SMM::UnitSize;
import series::first::SMM::UnitTesting;

public loc project0 = |project://smallsql0.21_src|;
public loc project1 = |project://hsqldb-2.3.1|;
// test project
public loc project2 = |project://HelloWorld|;

public void displayIndex(loc project) {
	map[str, int] pp = getProductProperties(project);
	println("-----------------------------------");
	printMI(pp);
	println("-----------------------------------");
	map[str, int] mi = productPropertiesToMaintainabilityIndex(pp);
	printMI(mi);
}

public map[str, int] productPropertiesToMaintainabilityIndex(map[str, int] pp) {
	println("analisability : (<pp["Volume"]> + <pp["Duplication"]> + <pp["UnitSize"]> + <pp["UnitTesting"]>) / 4");
	println("Res: <(pp["Volume"] + pp["Duplication"] + pp["UnitSize"] + pp["UnitTesting"]) / 4>");
	println("changeability : (<pp["Complexity"]> + <pp["Duplication"]>) / 2,");
	println("Res: <(pp["Complexity"] + pp["Duplication"]) / 2>");
	println("stability		: (<pp["UnitTesting"]>),");
	println("Res: <(pp["UnitTesting"])>");
	println("testability	: (<pp["Complexity"]> + <pp["UnitSize"]> + <pp["UnitTesting"]>) / 3");
	println("Res: <(pp["Complexity"] + pp["UnitSize"] + pp["UnitTesting"]) / 3>");
	return (
		"analisability" : (pp["Volume"] + pp["Duplication"] + pp["UnitSize"] + pp["UnitTesting"]) / 4,
		"changeability" : (pp["Complexity"] + pp["Duplication"]) / 2,
		"stability"		: (pp["UnitTesting"]),
		"testability"	: (pp["Complexity"] + pp["UnitSize"] + pp["UnitTesting"]) / 3
	);
}

public map[str, int] getProductProperties(loc project) {
	return (
		"Volume" 		: getScoreOfVolume(project),
		"Complexity" 	: getScoreOfComplexity(project),
		"Duplication"	: getScoreOfDuplication(project),
		"UnitSize"		: getScoreOfUnitSize(project),
		"UnitTesting"	: getScoreOfUnitTesting(project)
	);	
}

public void printMI (map[str, int] mapMI) {
	for(x <- mapMI) { 
		println("<x>: \t<measureToString(mapMI[x])>");
	}
}

public str measureToString(int measure) {
	switch (measure) {
		case 2:  return "++";
		case 1:  return "+";
		case 0:  return "o";
		case -1: return "-";
		case -2: return "--";
	}
}

// example from the paper
public map[str, int] pp1 = (	
	"Volume" 		: 2,
	"Complexity" 	: -2,
	"Duplication"	: -1,
	"UnitSize"		: -1,
	"UnitTesting"	: 0
	);
	
public map[str, int] mi1 = (	
	"analisability" : 0,
	"changeability" : -1,
	"stability"		: 0,
	"testability"	: -1
	);
	
public test bool ppToMI1() = mi1 == productPropertiesToMaintainabilityIndex(pp1);