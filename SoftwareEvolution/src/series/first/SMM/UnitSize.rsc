module series::first::SMM::UnitSize

import IO;
import List;
import Map;

import series::first::SMM;
import series::first::SMM::Volume;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

public int getScoreOfUnitSize(loc project) {
	map[loc, int] sizes = getUnitSizePerFile(project);
	
	int total = size(sizes);
	int veryHigh = size((x : sizes[x] | x <- sizes, sizes[x] > 100));
	int high = size((x : sizes[x] | x <- sizes, sizes[x] <= 100, sizes[x] > 50 ));
	int medium = size((x : sizes[x] | x <- sizes, sizes[x] <= 50, sizes[x] > 10 ));
	
	int percVeryHigh 	= veryHigh 	* 100 / total;
	int percHigh 		= high 		* 100 / total;
	int percMedium		= medium	* 100 / total;
	
	//based on information of http://docs.codehaus.org/display/SONAR/SIG+Maintainability+Model+Plugin
	if 		(percMedium <= 25 && percHigh <= 0  && percVeryHigh <= 0) return 2;
	else if (percMedium <= 30 && percHigh <= 5  && percVeryHigh <= 0) return 1;
	else if (percMedium <= 40 && percHigh <= 10 && percVeryHigh <= 0) return 0;
	else if (percMedium <= 50 && percHigh <= 15 && percVeryHigh <= 5) return -1;
	else 															  return -2;
}

public map[loc, int] getUnitSizePerFile(project) {
	return (method:linesOfFile(method) | method <- methods(createM3FromEclipseProject(project)));
}

public loc testFile0 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/EmptyClass.java|;
public loc testFile1 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/NormalClass.java|;
public loc testFile2 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/SingleCommentedClass.java|;
public loc testFile3 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/MultilineCommentedClass.java|;
public loc testFile4 = |project://SoftwareEvolution/src/test/series/first/SMM/Volume/Annotations.java|;


public test bool linesInFile0() = linesOfFile(testFile0) == 3;
public test bool linesInFile1() = linesOfFile(testFile1) == 6;
public test bool linesInFile2() = linesOfFile(testFile2) == 6;
public test bool linesInFile3() = linesOfFile(testFile3) == 6;
public test bool linesInFile3() = linesOfFile(testFile4) == 39;