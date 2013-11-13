module series::first::SMM::UnitSize

import IO;
import List;
import Map;
import util::Math;

import series::first::SMM;
import series::first::SMM::Volume;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

public int getScoreFromMatrix(num percVeryHigh, num percHigh, num percMedium) {
	//based on information of http://docs.codehaus.org/display/SONAR/SIG+Maintainability+Model+Plugin
	if 		(percMedium <= 25 && percHigh <= 0  && percVeryHigh <= 0) return 5;
	else if (percMedium <= 30 && percHigh <= 5  && percVeryHigh <= 0) return 4;
	else if (percMedium <= 40 && percHigh <= 10 && percVeryHigh <= 0) return 3;
	else if (percMedium <= 50 && percHigh <= 15 && percVeryHigh <= 5) return 2;
	else 															  return 1;
}

public int getScoreOfUnitSize(loc project) {
	logMessage("Calculating size per unit...", 1);
	map[loc, num] sizes = getUnitSizePerMethod(project);
	
	num total = size(sizes);
	num veryHigh = size((x : sizes[x] | x <- sizes, sizes[x] > 100));
	num high = size((x : sizes[x] | x <- sizes, sizes[x] <= 100, sizes[x] > 50 ));
	num medium = size((x : sizes[x] | x <- sizes, sizes[x] <= 50, sizes[x] > 10 ));
	
	num percVeryHigh 	= round(veryHigh 	/ total) * 100;
	num percHigh 		= round(high 		/ total) * 100;
	num percMedium		= round(medium		/ total) * 100;

	
	/** debug information **/
	logMessage("Very high: <veryHigh>.", 2);
	logMessage("High: <high>.", 2);
	logMessage("Medium: <medium>.", 2);
	
	logMessage("Very high: <medium>%.", 2);
	logMessage("High: <medium>%.", 2);
	logMessage("Medium: <medium>%.", 2);
	/** end of debug information **/
	
	int score = getScoreFromMatrix(percVeryHigh, percHigh, percMedium);
	logMessage("-- Result: <total> methods initialized. Score: <score>.", 1);
	return score;
}

public map[loc, num] getUnitSizePerMethod(project) {
	return (method:size(linesOfFile(method)) | method <- methods(createM3FromEclipseProject(project)));
}

public loc testFile0 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/EmptyClass.java|;
public loc testFile1 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/NormalClass.java|;
public loc testFile2 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/SingleCommentedClass.java|;
public loc testFile3 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/MultilineCommentedClass.java|;
public loc testFile4 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/Annotations.java|;


public test bool linesInFile0() = size(linesOfFile(testFile0)) == 3;
public test bool linesInFile1() = size(linesOfFile(testFile1)) == 6;
public test bool linesInFile2() = size(linesOfFile(testFile2)) == 6;
public test bool linesInFile3() = size(linesOfFile(testFile3)) == 6;
public test bool linesInFile3() = size(linesOfFile(testFile4)) == 39;