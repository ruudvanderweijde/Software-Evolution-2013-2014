module series::first::SMM::Volume

import IO;
import List;
import String;
import series::first::SMM;
import lang::java::jdt::Project;

public int getLinesOfJava(loc project) {
	return (0 | it + size(linesOfFile(f)) | loc f <- sourceFilesForProject(project));
}

public int getScoreOfVolume(loc project) {
	logMessage("Calculating lines of code...", 1);
	int linesOfJava = getLinesOfJava(project);
	int score = getScoreForLines(linesOfJava);
	logMessage("-- Result: <linesOfJava> lines of code found. Score: <score>", 1);
	return score;
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

private str stripMultiLineComments(str fileString) {
	// match /* to */, but /* must not be between strings, like String = " /* ";
	for (/<commentML:(?=(?:[^"\\]*(?:\\.|"(?:[^"\\]*\\.)*[^"\\]*"))*[^"]*$)\/\*(?s).*?\*\/>/ := fileString) {
		if (/\n/ := commentML) {
			// if the comment contains new lines, replace it with a new line
			fileString = replaceFirst(fileString, commentML, "\n");
		} else {
			fileString = replaceFirst(fileString, commentML, "");
		}
	}
	return fileString;
}

private int getScoreForLines(int linesOfJava) {
	if 		(linesOfJava < 66000)	return 2;
	else if (linesOfJava < 246000)	return 1;
	else if (linesOfJava < 665000)	return 0;
	else if (linesOfJava < 1310000)	return -1;
	else 							return -2;
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
