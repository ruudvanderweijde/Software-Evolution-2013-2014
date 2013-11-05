module series::first::AST

import IO;
import List;
import series::first::LinesOfCode;
import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

public loc project0 = |project://smallsql0.21_src|;
public loc project1 = |project://hsqldb-2.3.1|;
public loc project2 = |project://HelloWorld|;

public void displayInformation(loc project) {
	println("linesOfProject = <linesOfProject(project)>");
	
	fullModel = createM3FromEclipseProject(project);
	
	int numberOfMethods(loc cl, M3 model) = size([ m | m <- model@containment[cl], isMethod(m)]);
	map[loc class, int methodCount] numberOfMethodsPerClass = (cl:numberOfMethods(cl, fullModel) | <cl,_> <- fullModel@containment, isClass(cl));
	
	println("numberOfMethodsPerClass = <numberOfMethodsPerClass>");
	
	set[loc] myMethods = methods(fullModel);
	println(myMethods);
	
	map[loc method, int lineCount] numberOfLinesPerMethod = (method:linesOfFile(method) | method <- myMethods);
	println("numberOfLinesPerMethod = <numberOfLinesPerMethod>");
	
}