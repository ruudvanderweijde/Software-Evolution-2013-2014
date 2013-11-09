module series::first::M3Example

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;
import lang::java::jdt::m3::AST;
import IO;

public int numberOfStatementsInProject() {
	myModel = createM3FromEclipseProject(|project://CodeAnalysisExamples|);
	//methods(myModel) returns set[loc]
	myMethods = methods(myModel);  
	int totalStmt = 0;
	for (methodLoc <- myMethods) { 
		methodAST = getMethodASTEclipse(methodLoc, model=myModel); 
		totalStmt = totalStmt + (0 | it + 1 | /Statement _ := methodAST);
	}
	return totalStmt; 
}

public void printTotaNumberOfStatementsInProject() {
	println("Total number of statements in the project: <numberOfStatementsInProject()>");
}


public void printStuff() {
	myModel = createM3FromEclipseProject(|project://CodeAnalysisExamples|);
	methodAST = getMethodASTEclipse(|java+method:///MyHelloWorld/a()|, model=myModel);
	int totalExp = (0 | it + 1 | /Expression _ := methodAST);
	int totalDecl = (0 | it + 1 | /Declaration _ := methodAST);
	int totalStmt = (0 | it + 1 | /Statement _ := methodAST);
	int totalType = (0 | it + 1 | /Type _ := methodAST);	
	int totalModif = (0 | it + 1 | /Modifier _ := methodAST);	
	int total = 0;	
	int totalMethodCalls = 0;
	
	iprintln(methodAST);
	visit(methodAST) {
		 case \declarationStatement(_) : total = total + 1 ;
		 case m:methodCall(_, _, _) : { iprintln(m); totalMethodCalls = totalMethodCalls + 1;}
		 case Statement _ : ;
	}
	myMethods = methods(myModel);
	println(myMethods);
    println ("Number of expressions: <totalExp>" );
    println ("Number of declarations:  <totalDecl> " );
    println ("Number of statements:  <totalStmt>" );
    println ("Number of type defs:  <totalType> " );    
    println ("Number of modifiers: <totalModif>" );        
    println ("pattern matching total <total>");
    println("Total number of method calls: <totalMethodCalls>"); 
    for (myLoc <- myModel@containment) { 
		println(myLoc);
	}
}
