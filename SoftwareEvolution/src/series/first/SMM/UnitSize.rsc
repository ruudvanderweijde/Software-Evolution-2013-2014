module series::first::SMM::UnitSize

import IO;
import List;
import Map;

import series::first::SMM::Volume;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

public str getScoreOfUnitSize(loc project) {
	map[loc, int] sizes = getUnitSizePerFile(project);
	
	//based on information of http://docs.codehaus.org/display/SONAR/SIG+Maintainability+Model+Plugin
	int total = size(sizes);
	int veryHigh = size((x : sizes[x] | x <- sizes, sizes[x] > 100));
	int high = size((x : sizes[x] | x <- sizes, sizes[x] <= 100, sizes[x] > 50 ));
	int medium = size((x : sizes[x] | x <- sizes, sizes[x] <= 50, sizes[x] > 10 ));
	
	int percVeryHigh 	= veryHigh 	* 100 / total;
	int percHigh 		= high 		* 100 / total;
	int percMedium		= medium	* 100 / total;
	
	if 		(percMedium <= 25 && percHigh <= 0  && percVeryHigh <= 0) return "++";
	else if (percMedium <= 30 && percHigh <= 5  && percVeryHigh <= 0) return "+";
	else if (percMedium <= 40 && percHigh <= 10 && percVeryHigh <= 0) return "o";
	else if (percMedium <= 50 && percHigh <= 15 && percVeryHigh <= 5) return "-";
	else 															 return "--";
}

public map[loc, int] getUnitSizePerFile(project) {
	fullModel = createM3FromEclipseProject(project);
	
	int numberOfMethods(loc cl, M3 model) = size([ m | m <- model@containment[cl], isMethod(m)]);
	map[loc class, int methodCount] numberOfMethodsPerClass = (cl:numberOfMethods(cl, fullModel) | <cl,_> <- fullModel@containment, isClass(cl));
	
	//println("numberOfMethodsPerClass = <numberOfMethodsPerClass>");
	
	set[loc] myMethods = methods(fullModel);
	//println(myMethods);
	
	map[loc method, int lineCount] numberOfLinesPerMethod = (method:linesOfFile(method) | method <- myMethods);
	//println("numberOfLinesPerMethod = <numberOfLinesPerMethod>");
	return numberOfLinesPerMethod;
	
}