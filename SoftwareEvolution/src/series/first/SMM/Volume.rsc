module series::first::SMM::Volume

import IO;
import List;
import String;
import series::first::SMM;
import lang::java::jdt::Project;

public int getLinesOfJava(loc project) {
	// temporary 'cache' these records
	if (project == project0) return 24111;
	if (project == project1) return 168932;
	// default function
	return (0 | it + linesOfFileSize(f) | loc f <- sourceFilesForProject(project));
}

public int getScoreOfVolume(loc project) {
	logMessage("Calculating lines of code...", 1);
	int linesOfJava = getLinesOfJava(project);
	int score = getScoreForLines(linesOfJava);
	logMessage("-- Result: <linesOfJava> lines of code found. Score: <score>", 1);
	return score;
}

public int counter = 0;

public int linesOfFileSize(loc file) {
	int count = 0; 
	counter += 1;
	//println("<counter> :: reading file: <file>");
	for (line <- split("\n", stripMultiLineComments(readFile(file)))) {
		// skip empty lines
		if (/^[ \t]*$/ := line) {
			continue;
		}
		// skip lines starting with //
		if (/^[ \t]*\/\// := line) {
			continue;
		}
		count += 1;
	}
	return count;

}

public list[str] linesOfFile(loc file) {
	return 
		for (line <- split("\n", stripMultiLineComments(readFile(file)))) {
			// skip empty lines
			if (/^[ \t]*$/ := line) {
				continue;
			}
			// skip lines starting with //
			if (/^[ \t]*\/\// := line) {
				continue;
			}
			append line;
		};
}

public list[str] linesOfFileWithComments(loc file) {
	return 
		for (line <- split("\n", readFile(file))) {
			// skip empty lines
			if (/^[ \t]*$/ := line) {
				continue;
			}
			append line;
		};
}

private str stripMultiLineComments(str fileString) {
	// match /* to */, but /* must not be between strings, like String = " /* ";
	for (/<commentML:(?=(?:[^"\\]*(?:\\.|"(?:[^"\\]*\\.)*[^"\\]*"))*[^"]*$)\/\*(?s).*?\*\/>/ := fileString) {
		//print(" .");
		if (/\n/ := commentML) {
			// if the comment contains new lines, replace it with a new line
			fileString = replaceFirst(fileString, commentML, "\n");
		} else {
			fileString = replaceFirst(fileString, commentML, "");
		}
	}
	//println(" ");
	return fileString;
}

private int getScoreForLines(int linesOfJava) {
	if 		(linesOfJava < 66000)	return 5;
	else if (linesOfJava < 246000)	return 4;
	else if (linesOfJava < 665000)	return 3;
	else if (linesOfJava < 1310000)	return 2;
	else 							return 1;
}

private loc testFile0 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/EmptyClass.java|;
private loc testFile1 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/NormalClass.java|;
private loc testFile2 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/SingleCommentedClass.java|;
private loc testFile3 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/MultilineCommentedClass.java|;
private loc testFile4 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/Annotations.java|;


public test bool linesInFile0() = size(linesOfFile(testFile0)) == 3;
public test bool linesInFile1() = size(linesOfFile(testFile1)) == 6;
public test bool linesInFile2() = size(linesOfFile(testFile2)) == 6;
public test bool linesInFile3() = size(linesOfFile(testFile3)) == 6;
public test bool linesInFile3() = size(linesOfFile(testFile4)) == 39;
