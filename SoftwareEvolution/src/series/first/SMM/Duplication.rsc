module series::first::SMM::Duplication

import IO;
import String;
import List;
import Set;
import Map;
import Relation;
import util::Math;

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
	tuple[num totalLines, num dupeLines] result = getDuplicationUsingStringMatching(sourceFilesForProject(project));
	//tuple[num allLines, num dupeLines] result = getDuplicationUsingListMatching(sourceFilesForProject(project));
		
	logMessage("debug: total lines: <result.totalLines>", 2);
	logMessage("debug: total dupes: <result.dupeLines>", 2);
	
	return round((result.dupeLines / result.totalLines) * 100);
}

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

public bool testBothVersions(loc file) {
	return getDuplicationUsingStringMatching(file) == getDuplicationUsingListMatching(file);
}
public loc testDupe0 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/NoDuplication.java|;
public loc testDupe1 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/Duplication0.java|;
public loc testDupe2 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/Duplication12.java|;
public loc testDupe3 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/Duplication34.java|;
public loc testDupe4 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/Duplication100.java|;


public test bool compareFunctions0() = testBothVersions({testDupe0});
public test bool compareFunctions1() = testBothVersions({testDupe1});
public test bool compareFunctions2() = testBothVersions({testDupe2});
public test bool compareFunctions3() = testBothVersions({testDupe3});
public test bool compareFunctions4() = testBothVersions({testDupe4});

public test bool dupesInFile0() = <_, dupes> := getDuplicationUsingStringMatching({testDupe0}) && dupes == 0;
public test bool dupesInFile1() = <_, dupes> := getDuplicationUsingStringMatching({testDupe1}) && dupes == 0;
public test bool dupesInFile2() = <_, dupes> := getDuplicationUsingStringMatching({testDupe2}) && dupes == 12;
public test bool dupesInFile3() = <_, dupes> := getDuplicationUsingStringMatching({testDupe3}) && dupes == 38;
public test bool dupesInFile4() = <_, dupes> := getDuplicationUsingStringMatching({testDupe4}) && dupes == 100;