module series::first::SMM
/* SMM: Sig Maintanability Model */

import IO;
import List;

import lang::java::m3::Core;
import lang::java::jdt::m3::Core;

import series::first::SMM::Volume;
import series::first::SMM::Complexity;
import series::first::SMM::Duplication;
import series::first::SMM::UnitSize;
import series::first::SMM::UnitTesting;

public loc project0 = |project://smallsql0.21_src|;
public loc project1 = |project://hsqldb-2.3.1|;
// test project
public loc project2 = |project://HelloWorld|;

public void displayIndex(loc project) {
	println("Volume = <getScoreOfVolume(project)>");
	println("Complexity = <getScoreOfComplexity(project)>");
	println("Duplication = <getScoreOfDuplication(project)>");
	println("UnitSize = <getScoreOfUnitSize(project)>");
	println("UnitTesting = <getScoreOfUnitTesting(project)>");	
}

