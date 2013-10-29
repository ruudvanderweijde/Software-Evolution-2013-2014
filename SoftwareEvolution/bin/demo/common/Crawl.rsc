module demo::common::Crawl

import IO;
import String;
import List;

public list[loc] crawl(loc dir, str suffix){
  res = [];
  for(str entry <- listEntries(dir)){
      loc sub = dir + entry;   
      if(isDirectory(sub)) {
          res += crawl(sub, suffix);
      } else {
	         if(endsWith(entry, suffix)) { 
	             res += [sub]; 
	         }
      }
  };
  return res;
}


public list[loc] crawl2(loc dir, str suffix){
println ("dir: <dir>");
	  return 
	  for(str entry <- listEntries(dir)){
	      loc sub = dir + entry;  
	      
	      if(isDirectory(sub)) {
	      			    append reducer ((crawl(sub, suffix)), mergeCustom, []);  
	      } else {
		          if(endsWith(entry, suffix)) {
		          println("sub: <sub>");
		          	    append reducer ([sub], mergeCustom, []);
		          	}
	      }
	  };
}

public list[loc] mergeCustom(list[loc] x, list[loc] y) { return merge (x, y); }

public list[loc] crawl3(loc dir, str suffix) =
  isDirectory(dir) ? [crawl(e,suffix) | e <- dir.ls] : (dir.extension == suffix ? [dir] : []);