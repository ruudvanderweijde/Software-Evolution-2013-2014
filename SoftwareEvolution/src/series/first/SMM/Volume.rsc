module series::first::SMM::Volume

import IO;
import String;
import lang::java::jdt::Project;

public str getScoreOfVolume(loc project) {
	int linesOfJava = linesOfProject(project);
	
	if 		(linesOfJava < 66000)	return "++";
	else if (linesOfJava < 246000)	return "+";
	else if (linesOfJava < 665000)	return "o";
	else if (linesOfJava < 1310000)	return "-";
	else 							return "--";
}

public int linesOfProject(loc project) {
	set[value] files = sourceFilesForProject(project);
	int totalLines = 0;
	for (file <- files) {
		totalLines += linesOfFile(file);
	}
	return totalLines;
}
	
public int linesOfFile(loc file) {
	int res = 0;
	str fileString = readFile(file);
	// strip multiline comments
	for (/<commentML:\/\*(?s).*?\*\/>/ := fileString) {
		if (/\n/ := commentML) {
			// if the comments contain new lines, replace it with a new line
			fileString = replaceFirst(fileString, commentML, "\n");
		} else {
			fileString = replaceFirst(fileString, commentML, "");
		}
	}
	for (line <- split("\n", fileString)) {
		// skip empty lines
		if (/^[ \t]*$/ := line) {
			continue;
		}
		// skip lines starting with //
		if (/^[ \t]*\/\// := line) {
			continue;
		}
		res += 1;
	};
	return res;
}

private loc testFile0 = |project://SoftwareEvolution/src/test/series/first/loc/EmptyClass.java|;
private loc testFile1 = |project://SoftwareEvolution/src/test/series/first/loc/NormalClass.java|;
private loc testFile2 = |project://SoftwareEvolution/src/test/series/first/loc/SingleCommentedClass.java|;
private loc testFile3 = |project://SoftwareEvolution/src/test/series/first/loc/MultilineCommentedClass.java|;
private loc testFile4 = |project://SoftwareEvolution/src/test/series/first/loc/Annotations.java|;


public test bool linesInFile0() = linesOfFile(testFile0) == 3;
public test bool linesInFile1() = linesOfFile(testFile1) == 6;
public test bool linesInFile2() = linesOfFile(testFile2) == 6;
public test bool linesInFile3() = linesOfFile(testFile3) == 6;
public test bool linesInFile3() = linesOfFile(testFile4) == 39;
