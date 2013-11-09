module series::first::SMM::Duplication

import IO;
import String;
import List;
import Set;
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

public num getPrecentageOfDuplication(loc project) {
	list[str] allLines = ([] | it + (linesOfFile(f)) | loc f <- sourceFilesForProject(project));
	str allLinesTogether = intercalate("\n", allLines);
	// this will contain the keys of allLines list which are duplicate lines.
	set[int] duplicateLines = {};
	for (startLine <- [0..(size(allLines)-duplicationBlock)]) {
		str searchString = intercalate("\n", slice(allLines, startLine, duplicationBlock));
		if (size(findAll(allLinesTogether, searchString)) > 1) {
			duplicateLines += toSet([startLine..(startLine+duplicationBlock)]);
		}
	}
	num totalLines = size(allLines);
	//println("total lines: <totalLines>");
	num totalDupes = size(toList(duplicateLines));
	//println("total dupes: <totalDupes>");
	
	num percDupes = (totalDupes / totalLines) * 100;
	println("debug: precentage dupes: <percDupes>");
	
	return percDupes;
}