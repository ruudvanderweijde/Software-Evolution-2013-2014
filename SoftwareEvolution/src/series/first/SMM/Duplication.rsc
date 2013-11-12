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

public num getPrecentageOfDuplicationStringBased(loc project) {
	list[str] allLines = ([] | it + (linesOfFile(f)) | loc f <- sourceFilesForProject(project));
	//println("debug: allLines = <allLines>");
	str allLinesTogether = intercalate("\n", allLines);
	// this will contain the keys of allLines list which are duplicate lines.
	set[int] duplicateLines = {};
	for (startLine <- [0..(size(allLines)-duplicationBlock)]) {
		str searchString = intercalate("\n", slice(allLines, startLine, duplicationBlock));
		if (size(findAll(allLinesTogether, searchString)) > 1) {
			//println("DUPES = <searchString>");
			duplicateLines += toSet([startLine..(startLine+duplicationBlock)]);
		}
	}
	
	//dupelines = [ allLines[x] | x <- duplicateLines];
	//println("debug: all duplicate lines: <sort(dupelines)>");
	
	num totalLines = size(allLines);
	println("debug: total lines: <totalLines>");
	num totalDupes = size(toList(duplicateLines));
	println("debug: total dupes: <totalDupes>");
	
	num percDupes = round((totalDupes / totalLines) * 100);
	println("debug: precentage dupes: <percDupes>");
	
	return percDupes;
}

public list[str] trimWhiteSpace(list[str] listOfLines) {
	return 
		for(line <- listOfLines) {
			for (/<whitespace:\s\s+>/ := line) {
				line = replaceFirst(line, whitespace, " ");
			}
			append trim(line);
		}
}

public num getPrecentageOfDuplication(loc project) {
	set[int] duplicateLines = {};
	
	int beginLine = 0;
	int numberOfLines = 0;
	
	list[str] allLines = [];
	map[loc, tuple[int beginLine, int endLine]] fileLineIndex = ();
	// get all the code of the project
	for(f <- sourceFilesForProject(project)) {
		numberOfLines = size(linesOfFile(f));
		fileLineIndex += (f:<beginLine,beginLine+numberOfLines-1>);
		beginLine = beginLine+numberOfLines;
		// fill allLines to match parts of the data
		allLines += trimWhiteSpace(linesOfFile(f));
	}
	
	println("max map: <max(range(range(fileLineIndex)))>");
	println("size of allLines: <size(allLines)>");
	println("fileLineIndex: <fileLineIndex>");
	//exit;
	
	for (startLine <- [0..(size(allLines)-duplicationBlock)]) {
		list[str] possibleDuplicationBlock = slice(allLines, startLine, duplicationBlock);
		if ([*_, possibleDuplicationBlock, *_, possibleDuplicationBlock, *_] := allLines) {
			duplicateLines += toSet([startLine..(startLine+duplicationBlock)]);
		}
	}
	
	//dupelines = [ allLines[x] | x <- duplicateLines];
	//println("all duplicate lines: <dupelines>");
	
	num totalLines = size(allLines);
	println("total lines: <totalLines>");
	num totalDupes = size(toList(duplicateLines));
	println("total dupes: <totalDupes>");
	
	num percDupes = (totalDupes / totalLines) * 100;
	println("debug: precentage dupes: <percDupes>");
	
	return percDupes;
}