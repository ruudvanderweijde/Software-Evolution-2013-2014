module series::first::SMM::Duplication

import IO;
import String;
import List;
import Set;
import Map;
import Relation;
import util::Math;
import util::Benchmark;

import series::first::SMM;
import series::first::SMM::Volume;
import lang::java::jdt::Project;

private int duplicationBlock = 6;

public int getScoreOfDuplication(loc project) {
	logMessage("Calculating duplicate lines...", 1);
	num percentage = getPrecentageOfDuplication(project);
	int score = getScore(percentage);
	logMessage("-- Result <percentage>% of duplicate code found. Score: <score>.", 1);
	return score;
}

private int getScore(num percentage) {
	if 		(percentage <= 3)	return 5;
	else if (percentage <= 5)	return 4;
	else if (percentage <= 10)	return 3;
	else if (percentage <= 20)	return 2;
	else 						return 1;	
}
private num getPrecentageOfDuplication(loc project) {
	// method matching strings is faster then matching lists;
	tuple[num totalLines, num dupeLines] result = testDuplicationUsingStringMatching(sourceFilesForProject(project), false, true);
	//tuple[num totalLines, num dupeLines] result = getDuplicationUsingStringMatching(sourceFilesForProject(project));
	//tuple[num allLines, num dupeLines] result = getDuplicationUsingListMatching(sourceFilesForProject(project));
		
	logMessage("debug: total lines: <result.totalLines>", 2);
	logMessage("debug: total dupes: <result.dupeLines>", 1);
	
	return round((result.dupeLines / result.totalLines) * 100);
}

// this function is deprecated
private tuple[num, num] getDuplicationUsingStringMatching(set[loc] files) {
	// this set will contain the keys of allLines list which are duplicate lines.
	set[int] duplicateLines = {};
	
	list[str] allLines = ([] | it + [ trim(line) | line <- linesOfFile(f) ] | loc f <- files);
	str allLinesTogether = intercalate("\n", allLines);
	
	for (startLine <- [0..(size(allLines)-duplicationBlock)]) {
		str searchString = "\n" + intercalate("\n", slice(allLines, startLine, duplicationBlock));
		if (size(findAll(allLinesTogether, searchString)) > 1) {
			// mark these items as duplicate lines		
			duplicateLines += toSet([startLine..(startLine+duplicationBlock)]);
		}
	}
 	//println("debug: all duplicate lines: <[ allLines[x] | x <- duplicateLines]>");
	
	return <size(allLines),size(duplicateLines)>;
}

// this function is deprecated
private tuple[num, num] getDuplicationUsingListMatching(set[loc] files) {
	set[int] duplicateLines = {};
	
	int beginLine = 0;
	int numberOfLines = 0;
	
	list[str] allLines = [];
	map[loc, tuple[int beginLine, int endLine]] fileLineIndex = ();
	// get all the code of the project
	for(f <- files) {
		numberOfLines = size(linesOfFile(f));
		fileLineIndex += (f:<beginLine,beginLine+numberOfLines-1>);
		beginLine = beginLine+numberOfLines;
		// fill allLines to match parts of the data
		allLines += [ trim(line) | line <- linesOfFile(f) ];
	}
	
	for (startLine <- [0..(size(allLines)-duplicationBlock)]) {
		list[str] possibleDuplicationBlock = slice(allLines, startLine, duplicationBlock);
		if ([*_, possibleDuplicationBlock, *_, possibleDuplicationBlock, *_] := allLines) {
			//println("debug: match on total line: <startLine>");
			duplicateLines += toSet([startLine..(startLine+duplicationBlock)]);
		}
	}
	//println("debug: all duplicate lines: <[ allLines[x] | x <- duplicateLines]>");
	
	return <size(allLines),size(duplicateLines)>;
}

@doc {
Benchmarking the different methods and their results...

+-----------------+--------------------+-----------------+-----------------+------------------+
|     Project     | NoComments && Trim |   NoComments    |      Trim       | No modifications |
+-----------------+--------------------+-----------------+-----------------+------------------+
| SmallSQL        | 11,3               | 9,5             | 26,3            | 27,6             |
| HelloWorld      | 45,7               | 40,1            | 34,5            | 35,1             |
| QL              | 28,9               | 27,6            | 26,3            | 27,7             |
| HSQLDB          | 17,7               | 16,4            | 26,5            | 27,5             |
| --------------- | ---------------    | --------------- | --------------- | ---------------  |
| SmallSQL Time   | 468s               | 528s            | 164s            | 185s             |
| HelloWorld Time | 0,3s               | 0,2s            | 0s              | 0s               |
| QL Time         | 100s               | 96s             | 6s              | 7s               |
| HSQLDB Time     | 15240s             | 13732s          | 9458s           | 8622s            |
+-----------------+--------------------+-----------------+-----------------+------------------+

}
public void triggerMethods() {
	//logMessage("project0: <project0>",1);
	//println("<benchmark(
	//(	"tripMLC,trim" 	: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project0), true, true);},
	//	"tripMLC" 		: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project0), true, false);},
	//	"trim" 			: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project0), false, true);},
	//	"none" 			: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project0), false, false);}
	//))>");
	
	logMessage("project1: <project1>",1);
	println("<benchmark(
	(	"tripMLC,trim" 	: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project1), true, true);},
		"tripMLC" 		: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project1), true, false);},
		"trim" 			: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project1), false, true);},
		"none" 			: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project1), false, false);}
	))>");
	
	//logMessage("project2: <project2>",1);
	//println("<benchmark(
	//(	"tripMLC,trim" 	: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project2), true, true);},
	//	"tripMLC" 		: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project2), true, false);},
	//	"trim" 			: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project2), false, true);},
	//	"none" 			: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project2), false, false);}
	//))>");
	
	//logMessage("project3: <project3>",1);
	//println("<benchmark(
	//(	"tripMLC,trim" 	: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project3), true, true);},
	//	"tripMLC" 		: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project3), true, false);},
	//	"trim" 			: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project3), false, true);},
	//	"none" 			: void() {testDuplicationUsingStringMatching(sourceFilesForProject(project3), false, false);}
	//))>");

}

public tuple[num, num] testDuplicationUsingStringMatching(set[loc] files, bool stripMLC, bool useTrim) {
	// this set will contain the keys of allLines list which are duplicate lines.
	set[int] duplicateLines = {};
	list[str] allLines = [];
	if (useTrim && stripMLC) {
		allLines = ([] | it + [ trim(line) | line <- linesOfFile(f) ] | loc f <- files);
	} else if (useTrim && !stripMLC) {
		allLines = ([] | it + [ trim(line) | line <- linesOfFileWithComments(f) ] | loc f <- files);
	} else if (!useTrim && stripMLC) {
		allLines = ([] | it + [ line | line <- linesOfFile(f) ] | loc f <- files);
	} else if (!useTrim && !stripMLC) {
		allLines = ([] | it + [ line | line <- linesOfFileWithComments(f) ] | loc f <- files);
	}
	str allLinesTogether = intercalate("\n", allLines);
	
	for (startLine <- [0..(size(allLines)-duplicationBlock)]) {
		str searchString = "\n" + intercalate("\n", slice(allLines, startLine, duplicationBlock));
		if (size(findAll(allLinesTogether, searchString)) > 1) {
			// mark these items as duplicate lines		
			duplicateLines += toSet([startLine..(startLine+duplicationBlock)]);
		}
	}
 	//println("debug: all duplicate lines: <[ allLines[x] | x <- duplicateLines]>");
 	num lines = size(allLines);
 	num dupes = size(duplicateLines);
 	//println("<<lines,dupes>> | <(size(duplicateLines)/size(allLines))>% | <(dupes/lines)*100>");
	
	return <lines,dupes>;
}
public bool testBothVersions(loc file) {
	return getDuplicationUsingStringMatching(file) == getDuplicationUsingListMatching(file);
}
public loc testDupe0 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/NoDuplication.java|;
public loc testDupe1 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/Duplication0.java|;
public loc testDupe2 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/Duplication12.java|;
public loc testDupe3 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/Duplication34.java|;
public loc testDupe4 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/Duplication100.java|;

// These need updates
//public test bool compareFunctions0() = testBothVersions({testDupe0});
//public test bool compareFunctions1() = testBothVersions({testDupe1});
//public test bool compareFunctions2() = testBothVersions({testDupe2});
//public test bool compareFunctions3() = testBothVersions({testDupe3});
//public test bool compareFunctions4() = testBothVersions({testDupe4});

public test bool dupesInFile0() = <_, dupes> := getDuplicationUsingStringMatching({testDupe0}) && dupes == 0;
public test bool dupesInFile1() = <_, dupes> := getDuplicationUsingStringMatching({testDupe1}) && dupes == 0;
public test bool dupesInFile2() = <_, dupes> := getDuplicationUsingStringMatching({testDupe2}) && dupes == 12;
public test bool dupesInFile3() = <_, dupes> := getDuplicationUsingStringMatching({testDupe3}) && dupes == 38;
public test bool dupesInFile4() = <_, dupes> := getDuplicationUsingStringMatching({testDupe4}) && dupes == 100;