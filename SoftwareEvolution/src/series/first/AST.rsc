module series::first::AST

import IO;
import series::first::LinesOfCode;
import lang::java::jdt::m3::AST;

import demo::lang::Exp::Concrete::WithLayout::Syntax;
import ParseTree;
import vis::Figure;
import vis::ParseTree;
import vis::Render;

public loc project0 = |project://smallsql0.21_src|;
public loc project1 = |project://hsqldb-2.3.1|;

public void displayInformation(loc project) {
	println("Total lines of code: <linesOfProject(project)>");
	set[Declaration] fullAST = createAstsFromEclipseProject(project, true);
	render(visParsetree(fullAST));
}