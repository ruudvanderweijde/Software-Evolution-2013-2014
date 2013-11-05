module series::first::LinesOfCode

import IO;
import lang::java::jdt::Project;

public int linesOfProject(loc project) {
	set[value] files = sourceFilesForProject(project);
	int totalLines = 0;
	for (file <- files) {
	//println("<file>");
		totalLines += linesOfFile(file);
	}
	return totalLines;
}
	
public int linesOfFile(loc file) {
	int res = 0;
	bool comment = false;
	for (line <- readFileLines(file)) {
		// skip empty lines
		if (/^[ \t]*$/ := line) {
			continue;
		}
		// skip lines starting with //
		if (/^[ \t]*\/\// := line) {
			continue;
		}
		// start of marking code as commented
		if (/\/\*/ := line) {
			//println("start of comment: <line>");
			comment = true;
		}
		if (comment == false) {
			res += 1;
		}
		// end of marking code as commented
		if (/\*\// := line) {
			//println("end of comment: <line>");
			comment = false;
		}
	};
	return res;
}

private loc testFile0 = |project://SoftwareEvolution/src/test/series/first/EmptyClass.java|;
private loc testFile1 = |project://SoftwareEvolution/src/test/series/first/NormalClass.java|;
private loc testFile2 = |project://SoftwareEvolution/src/test/series/first/SingleCommentedClass.java|;
private loc testFile3 = |project://SoftwareEvolution/src/test/series/first/MultilineCommentedClass.java|;

public test bool linesInFile0() = linesInFile(testFile0) == 3;
public test bool linesInFile1() = linesInFile(testFile1) == 6;
public test bool linesInFile2() = linesInFile(testFile2) == 6;
public test bool linesInFile3() = linesInFile(testFile3) == 6;