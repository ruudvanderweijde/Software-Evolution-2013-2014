module series::first::SMM::UnitSize

import IO;
import List;
import Map;
import Set;
import util::Math;

import series::first::SMM;
import series::first::SMM::Volume;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

public int getScoreFromMatrix(num percVeryHigh, num percHigh, num percMedium) {
	// we use this meth
	if 		(percMedium <= 25 && percHigh <= 0  && percVeryHigh <= 0) return 5;
	else if (percMedium <= 30 && percHigh <= 5  && percVeryHigh <= 0) return 4;
	else if (percMedium <= 40 && percHigh <= 10 && percVeryHigh <= 0) return 3;
	else if (percMedium <= 50 && percHigh <= 15 && percVeryHigh <= 5) return 2;
	else 															  return 1;
}

@doc { this methods calculates precentages based on the lines of code

The difference between the methods:
			
SCORE		Method1		Method2 (old)

SmallSQL	1			4
	
HSQLDB		1			2

---------------------------------------------------------------
SMALL SQL
---------------------------------------------------------------
Details:	 
rascal>getScoreOfUnitSize(project0);
2013-11-18 13:00:38 :: Calculating size per unit...
2013-11-18 13:07:46 :: Very high: 1990.
2013-11-18 13:07:46 :: High: 2504.
2013-11-18 13:07:46 :: Medium: 8561.
2013-11-18 13:07:46 :: Very high: 8%.
2013-11-18 13:07:46 :: High: 10%.
2013-11-18 13:07:46 :: Medium: 36%.
2013-11-18 13:07:46 :: -- Result: 24111 methods initialized. Score: 1.
int: 1

rascal>getScoreOfUnitSizeOLD(project0);
2013-11-18 13:12:52 :: Calculating size per unit...
2013-11-18 13:13:48 :: Total size: 2400.
2013-11-18 13:13:48 :: Very high: 11.
2013-11-18 13:13:48 :: High: 39.
2013-11-18 13:13:48 :: Medium: 400.
2013-11-18 13:13:48 :: Very high: 0%.
2013-11-18 13:13:48 :: High: 2%.
2013-11-18 13:13:48 :: Medium: 17%.
2013-11-18 13:13:48 :: -- Result: 2400 methods initialized. Score: 4.
int: 4

---------------------------------------
HSQLDB
---------------------------------------
rascal>getScoreOfUnitSizeOLD(project1);
2013-11-18 13:15:56 :: Calculating size per unit...
2013-11-18 13:28:51 :: Total size: 10860.
2013-11-18 13:28:51 :: Very high: 154.
2013-11-18 13:28:51 :: High: 356.
2013-11-18 13:28:51 :: Medium: 3017.
2013-11-18 13:28:51 :: Very high: 1%.
2013-11-18 13:28:51 :: High: 3%.
2013-11-18 13:28:51 :: Medium: 28%.
2013-11-18 13:28:51 :: -- Result: 10860 methods initialized. Score: 2.
int: 2

2013-11-18 21:21:31 :: Calculating size per unit...
2013-11-18 21:33:32 :: Total size: 168932.
2013-11-18 21:33:32 :: Very high: 30403.
2013-11-18 21:33:32 :: High: 24520.
2013-11-18 21:33:32 :: Medium: 64768.
2013-11-18 21:33:32 :: Very high: 18%.
2013-11-18 21:33:32 :: High: 15%.
2013-11-18 21:33:32 :: Medium: 38%.
2013-11-18 21:33:32 :: -- Result: 168932 methods initialized. Score: 1.
int :1
}
public int getScoreOfUnitSize(loc project) {
	logMessage("Calculating size per unit...", 1);
	map[loc, num] sizes = getUnitSizePerMethod(project);
	
	//num total = sum(sizes);
	num total = getLinesOfJava(project);
	num veryHigh = sum([sizes[x] | x <- sizes, sizes[x] > 100]);
	num high = sum([sizes[x] | x <- sizes, sizes[x] <= 100, sizes[x] > 50 ]);
	num medium = sum([sizes[x] | x <- sizes, sizes[x] <= 50, sizes[x] > 10 ]);
	
	num percVeryHigh 	= round((veryHigh 	/ total) * 100);
	num percHigh 		= round((high 		/ total) * 100);
	num percMedium		= round((medium		/ total) * 100);

	
	/** debug information **/
	int log = 1;
	logMessage("Total size: <total>.", log);
	logMessage("Very high: <veryHigh>.", log);
	logMessage("High: <high>.", log);
	logMessage("Medium: <medium>.", log);
	
	logMessage("Very high: <percVeryHigh>%.", log);
	logMessage("High: <percHigh>%.", log);
	logMessage("Medium: <percMedium>%.", log);
	/** end of debug information **/
	
	int score = getScoreFromMatrix(percVeryHigh, percHigh, percMedium);
	logMessage("-- Result: <total> methods initialized. Score: <score>.", 1);
	return score;
}

@Doc { in this method we measure the unit size based on units, not on lines of code }
public int getScoreOfUnitSizeOLD(loc project) {
	//return 0; /* do not use this methods!!! */
	logMessage("Calculating size per unit...", 1);
	map[loc, num] sizes = getUnitSizePerMethod(project);
	
	logMessage("getUnitSizePerMethod done.", 1);
	
	num total = size(sizes);
	logMessage("total Size \'<total>\' done.", 1);
	num veryHigh = size((x : sizes[x] | x <- sizes, sizes[x] > 100));
	logMessage("veryHigh Size \'<veryHigh>\' done.", 1);
	num high = size((x : sizes[x] | x <- sizes, sizes[x] <= 100, sizes[x] > 50 ));
	logMessage("high Size \'<high>\' done.", 1);
	num medium = size((x : sizes[x] | x <- sizes, sizes[x] <= 50, sizes[x] > 10 ));
	logMessage("medium Size \'<medium>\' done.", 1);
	
	num percVeryHigh 	= round((veryHigh 	/ total) * 100);
	num percHigh 		= round((high 		/ total) * 100);
	num percMedium		= round((medium		/ total) * 100);

	
	/** debug information **/
	int log = 1;
	logMessage("Total size: <total>.", log);
	logMessage("Very high: <veryHigh>.", log);
	logMessage("High: <high>.", log);
	logMessage("Medium: <medium>.", log);
	
	logMessage("Very high: <percVeryHigh>%.", log);
	logMessage("High: <percHigh>%.", log);
	logMessage("Medium: <percMedium>%.", log);
	/** end of debug information **/
	
	int score = getScoreFromMatrix(percVeryHigh, percHigh, percMedium);
	logMessage("-- Result: <total> methods initialized. Score: <score>.", 1);
	return score;
}

public map[loc, num] getUnitSizePerMethod(project) {
	//allMethods = methods(createM3FromEclipseProject(project));
	//println("allMethods size: <size(allMethods)>");
	//return (method:linesOfFileSize(method) | method <- allMethods);
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