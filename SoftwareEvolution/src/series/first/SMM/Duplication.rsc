module series::first::SMM::Duplication

import IO;
import String;
import List;
import Set;
import Map;
import Relation;
import util::Math;
import series::first::SMM::Volume;
import lang::java::jdt::Project;

private int duplicationBlock = 6;

public int getScoreOfDuplication(loc project) {
	num percDuplicateLines = getPrecentageOfDuplication(project);
	
	if 		(percDuplicateLines <= 3)	return 2;
	else if (percDuplicateLines <= 5)	return 1;
	else if (percDuplicateLines <= 10)	return 0;
	else if (percDuplicateLines <= 20)	return -1;
	else 								return -2;	
}

public num runBoth(loc project) {
	// method matching strings is way faster then matching lists;
	getPrecentageOfDuplicationStringMatching(project);
	getPrecentageOfDuplicationListMatching(project);
}

public num getPrecentageOfDuplication(loc project) {
	// method matching strings is faster then matching lists;
	tuple[num allLines, num dupeLines] result = getDuplicationUsingStringMatching(project);
	//tuple[num allLines, num dupeLines] result = getDuplicationUsingListMatching(project);
		
	println("debug: total lines: <result.allLines>");
	println("debug: total dupes: <result.dupeLines>");
	
	num percDupes = round((result.dupeLines / result.allLines) * 100);
	println("debug: precentage dupes: <percDupes>");
	
	return percDupes;
}

public tuple[num, num] getDuplicationUsingStringMatching(loc project) {
	set[loc] files = isFile(project) ? {project} : sourceFilesForProject(project);
	println("files: <files>");
	list[str] allLines = ([] | it + [ trim(line) | line <-linesOfFile(f) ] | loc f <- files);
	//println("debug: allLines = <allLines>");
	str allLinesTogether = intercalate("\n", allLines);
	// this will contain the keys of allLines list which are duplicate lines.
	set[int] duplicateLines = {};
	for (startLine <- [0..(size(allLines)-duplicationBlock)]) {
		str searchString = intercalate("\n", slice(allLines, startLine, duplicationBlock));
		if (size(findAll(allLinesTogether, searchString)) > 1) {
			//println("debug: DUPES = <searchString>");
			duplicateLines += toSet([startLine..(startLine+duplicationBlock)]);
		}
	}
	
	tuple[num,num] result = <size(allLines),size(duplicateLines)>;
	return result;
}

public tuple[num, num] getDuplicationUsingListMatching(loc project) {
	set[int] duplicateLines = {};
	
	int beginLine = 0;
	int numberOfLines = 0;
	
	list[str] allLines = [];
	map[loc, tuple[int beginLine, int endLine]] fileLineIndex = ();
	// get all the code of the project
	// edit: or just one files, used for testcases.
	set[loc] files = isFile(project) ? {project} : sourceFilesForProject(project);
	println("files: <files>");
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
			duplicateLines += toSet([startLine..(startLine+duplicationBlock)]);
		}
	}
	
	tuple[num,num] result = <size(allLines),size(duplicateLines)>;
	return result;
}

// this method is not used anymore. It replaces whitespace.
private list[str] trimWhiteSpace(list[str] listOfLines) {
	return 
		for(line <- listOfLines) {
			for (/<whitespace:\s\s+>/ := line) {
				line = replaceFirst(line, whitespace, " ");
			}
			append trim(line);
		}
}

public bool testBothVersions(loc file) {
	return getDuplicationUsingStringMatching(file) == getDuplicationUsingListMatching(file);
}
public loc testDupe0 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/NoDuplication.java|;
public loc testDupe1 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/Duplication34.java|;
public loc testDupe2 = |project://SoftwareEvolution/src/test/series/first/SMM/Duplication/Duplication100.java|;


public test bool linesInFile0() = testBothVersions(testDupe0);
public test bool linesInFile1() = testBothVersions(testDupe1);
public test bool linesInFile2() = testBothVersions(testDupe2);

public test bool dupesInFile0() = <_, dupes> := getDuplicationUsingStringMatching(testDupe0) && dupes == 0;
public test bool dupesInFile1() = <_, dupes> := getDuplicationUsingStringMatching(testDupe1) && dupes == 34;
public test bool dupesInFile2() = <_, dupes> := getDuplicationUsingStringMatching(testDupe2) && dupes == 100;