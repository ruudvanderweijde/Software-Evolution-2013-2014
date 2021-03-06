module series::first::SMM
/* SMM: Sig Maintanability Model */

import IO;
import List;
import DateTime;
import util::Math;

import vis::Figure;
import vis::Render;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import series::first::SMM::Volume;
import series::first::SMM::Complexity;
import series::first::SMM::Duplication;
import series::first::SMM::UnitSize;
import series::first::SMM::UnitTesting;

public loc project0 = |project://smallsql0.21_src|;
public loc project1 = |project://hsqldb-2.3.1|;

// test projects
public loc project2 = |project://HelloWorld|;
public loc project3 = |project://QL|;
public loc projectUT1 = |project://UnitTest1|;
public loc projectUT2 = |project://UnitTest2|;
public loc projectUT3 = |project://UnitTest3|;
public loc projectUT4 = |project://UnitTest4|;
public loc projectUT5 = |project://UnitTest5|;

public loc project4 = |project://CodeAnalysisExamples|;
public loc project5 = |project://SmallSQL|;
public loc project6 = |project://HSQLDB|;


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
	int oi = overallIndex(mi);
	logMessage("Overall index: <measureToString(oi)>", 1);
	// display the image
	showImage(pp, mi, oi);
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

public map[str, num] productPropertiesToMaintainabilityIndex(map[str, num] pp) {
	return (
		"Analisability" : round((pp["Volume"] + pp["Duplication"] + pp["UnitSize"] + pp["UnitTesting"]) / 4),
		"Changeability" : round((pp["Complexity"] + pp["Duplication"]) / 2),
		"Stability"		: round((pp["UnitTesting"])),
		"Testability"	: round((pp["Complexity"] + pp["UnitSize"] + pp["UnitTesting"]) / 3)
	);
}

public int overallIndex(map[str, num] mi) {
	return round((mi["Analisability"] + mi["Changeability"] + mi["Stability"] + mi["Testability"]) / 4);
}

private void printMI (map[str, num] mapMI) {
	for(x <- mapMI) { 
		println("<x>: \t<measureToString(mapMI[x])>");
	}
}

private str measureToString(int measure) {
	switch (measure) {
		case 5: return "++";
		case 4: return "+";
		case 3: return "o";
		case 2: return "-";
		case 1: return "--";
	}
}

@doc { }
public void logMessage(str message, int level) {
	if (level <= logLevel) {
		str date = printDate(now(), "Y-MM-dd HH:mm:ss");
		println("<date> :: <message>");
	}
}

public void showImage(map[str, num] pp, map[str, num] mi, int oi) {
	// generate nodes
	nodes = [box(text(key + " (" + measureToString(pp[key]) + ")", fontSize(10)), id(key), fillColor(getColor(pp[key])), size(100,25)) | key <- pp];
	nodes += [box(text(key + " (" + measureToString(mi[key]) + ")", fontSize(15)), id(key), fillColor(getColor(mi[key])), size(140,40)) | key <- mi];
	// add Root node
	nodes += box(text("Overall Index (" + measureToString(oi) + ")", fontSize(20)), id("OveralIndex"), fillColor(getColor(oi)), size(220,55));
	
	// add connections between the components
	edges = [ edge("Analisability", "Volume"),
						edge("Analisability", "Duplication"),
						edge("Analisability", "UnitSize"),
						edge("Analisability", "UnitTesting"),
						
						edge("Changeability", "Complexity"),
						edge("Changeability", "Duplication"),
						
						edge("Stability", "UnitTesting"),
						
						edge("Testability", "Complexity"),
						edge("Testability", "UnitSize"),
						edge("Testability", "UnitTesting"),
						
						edge("OveralIndex", "Analisability", lineWidth(2), lineStyle("dashdot")),
						edge("OveralIndex", "Changeability", lineWidth(2), lineStyle("dashdot")),
						edge("OveralIndex", "Stability", lineWidth(2), lineStyle("dashdot")),
						edge("OveralIndex", "Testability", lineWidth(2), lineStyle("dashdot"))]; 

	// create the image and the legend.
	img = graph(nodes, edges, hint("layered"), gap(40));
	legend = hcat([box(text("<measureToString(i)>"), size(50,20), fillColor(color("<getColor(i)>", 0.9))) | i <- [1..6]]);
 	render(vcat([img, legend], gap(100),std(resizable(false))));
}

private str getColor(int score) {
	switch(score) {
		case 5: return "Green";
		case 4: return "Yellow";
		case 3: return "Orange";
		case 2: return "Red";
		case 1: return "Firebrick";
	}
}
/* test functions */

// example from the paper
public map[str, int] pp1 = (	
	"Volume" 		: 5, /* ++ */
	"Complexity" 	: 1, /* --*/
	"Duplication"	: 2, /* - */
	"UnitSize"		: 2, /* - */
	"UnitTesting"	: 3  /* o */
	);
	
public map[str, int] mi1 = (	
	"Analisability" : 3, /* o */
	"Changeability" : 2, /* - */
	"Stability"		: 3, /* o */
	"Testability"	: 2  /* - */
	);
	
public test bool ppToMI1() = mi1 == productPropertiesToMaintainabilityIndex(pp1);