module series::first::Analyse

import IO;

public int linesInDir(loc dir) {
  int res = 0;
  for(str entry <- listEntries(dir)){
      loc sub = dir + entry;   
      if(isDirectory(sub)) {
          res += linesInDir(sub);
      } else {
	      res += linesInFile(sub); 
      }
  };
  return res;
}

public int linesInFile(loc file) {
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
			println("start of comment: <line>");
			comment = true;
		}
		// end of marking code as commented
		if (/\*\// := line) {
			println("end of comment: <line>");
			comment = false;
		}
		if (comment == false) {
			res += 1;
		}
	};
	return res;
}