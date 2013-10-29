module demo::common::WordReplacement

import String;

// capitalize: convert first letter of a word to uppercase

public str capitalize(str word)  
{
   if(/^<letter:[a-z]><rest:.*$>/ := word){
     return toUpperCase(letter) + rest;
   } else {
     return word;
   }
}

// Capitalize all words in a string

// Version 1: capAll1: using a while loop

public str capAll1(str S)        
{
 result = "";
 while (/^<before:\W*><word:\w+><after:.*$>/ := S) { 
    result = result + before + capitalize(word);
    S = after;
  }
  return result;
}

// Version 2: capAll2: using visit

public str capAll2(str S)        
{
   return visit(S){
   	case /^<word:\w+>/ => capitalize(word)
   };
}