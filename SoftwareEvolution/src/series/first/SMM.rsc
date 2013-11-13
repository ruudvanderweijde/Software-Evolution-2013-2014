module series::first::SMM
/* SMM: Sig Maintanability Model */

import IO;
import List;
import DateTime;
import util::Math;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import series::first::SMM::Volume;
import series::first::SMM::CC;
import series::first::SMM::Duplication;
import series::first::SMM::UnitSize;
import series::first::SMM::UnitTesting;

public loc project0 = |project://smallsql0.21_src|;
public loc project1 = |project://hsqldb-2.3.1|;
// test project
public loc project2 = |project://HelloWorld|;

@logLevel {
	Log level 0 => no logging;
	Log level 1 => main logging;
	Log level 2 => debug logging;
}
private int logLevel = 1;

public void displayIndex(loc project) {
	map[str, num] pp = getProductProperties(project);
	logMessage("Product properties:", 1);
	printMI(pp);
	map[str, num] mi = productPropertiesToMaintainabilityIndex(pp);
	logMessage("Maintainability index:", 1);
	printMI(mi);
}

public map[str, num] productPropertiesToMaintainabilityIndex(map[str, num] pp) {
	return (
		"analisability" : round((pp["Volume"] + pp["Duplication"] + pp["UnitSize"] + pp["UnitTesting"]) / 4),
		"changeability" : round((pp["Complexity"] + pp["Duplication"]) / 2),
		"stability"		: round((pp["UnitTesting"])),
		"testability"	: round((pp["Complexity"] + pp["UnitSize"] + pp["UnitTesting"]) / 3)
	);
}

public map[str, num] getProductProperties(loc project) {
	return (
		"Volume" 		: getScoreOfVolume(project),
		"Complexity" 	: getScoreOfComplexity(project),
		"Duplication"	: getScoreOfDuplication(project),
		"UnitSize"		: getScoreOfUnitSize(project),
		"UnitTesting"	: getScoreOfUnitTesting(project)
	);
}

public void printMI (map[str, num] mapMI) {
	for(x <- mapMI) { 
		println("<x>: \t<measureToString(mapMI[x])>");
	}
}

public str measureToString(int measure) {
	switch (measure) {
		case 5:  return "++";
		case 4:  return "+";
		case 3:  return "o";
		case 2: return "-";
		case 1: return "--";
	}
}

public void logMessage(str message, int level) {
	if (level <= logLevel) {
		str date = printDate(now(), "Y-MM-dd HH:mm:ss");
		println("<date> :: <message>");
	}
}

/* test functions */

// example from the paper
public map[str, int] pp1 = (	
	"Volume" 		: 5,
	"Complexity" 	: 1,
	"Duplication"	: 2,
	"UnitSize"		: 2,
	"UnitTesting"	: 3
	);
	
public map[str, int] mi1 = (	
	"analisability" : 3,
	"changeability" : 2,
	"stability"		: 3,
	"testability"	: 2
	);
	
public test bool ppToMI1() = mi1 == productPropertiesToMaintainabilityIndex(pp1);