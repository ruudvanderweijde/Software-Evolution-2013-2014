module series::first::LinesOfCode

import IO;
import String;
import lang::java::jdt::Project;

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
	for (/<commentStart:\/\*><comment:(?s).*?><commentEnd:\*\/>/ := fileString) {
		fileString = replaceFirst(fileString, commentStart+comment+commentEnd, "");
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

public loc testFile0 = |project://SoftwareEvolution/src/test/series/first/EmptyClass.java|;
public loc testFile1 = |project://SoftwareEvolution/src/test/series/first/NormalClass.java|;
public loc testFile2 = |project://SoftwareEvolution/src/test/series/first/SingleCommentedClass.java|;
public loc testFile3 = |project://SoftwareEvolution/src/test/series/first/MultilineCommentedClass.java|;

public test bool linesInFile0() = linesOfFile(testFile0) == 3;
public test bool linesInFile1() = linesOfFile(testFile1) == 6;
public test bool linesInFile2() = linesOfFile(testFile2) == 6;
public test bool linesInFile3() = linesOfFile(testFile3) == 6;