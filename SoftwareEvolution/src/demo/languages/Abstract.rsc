module demo::languages::Abstract

import demo::lang::Exp::Abstract::Syntax;
import demo::lang::Exp::Abstract::Eval;


import demo::lang::Exp::Concrete::NoLayout::Syntax;

import String;
import ParseTree;              
                                   
lexical IntegerLiteral = [0-9]+; 
start syntax Exp            
  = IntegerLiteral          
  | bracket "(" Exp ")"     
  > left Exp "*" Exp        
  > left Exp "+" Exp        
  ;         
  
data Exp = con(int n)          
         | mul(Exp e1, Exp e2) 
         | div(Exp e1, Exp e2) 
         | add(Exp e1, Exp e2) 
         | sub(Exp e1, Exp e2) 
         ;

public int eval(con(int n)) = n;                            
public int eval(mul(Exp e1, Exp e2)) = eval(e1) * eval(e2); 
public int eval(div(Exp e1, Exp e2)) = eval(e1) / eval(e2); 
public int eval(add(Exp e1, Exp e2)) = eval(e1) + eval(e2); 
public int eval(sub(Exp e1, Exp e2)) = eval(e1) - eval(e2); 


// sadly this example does not work...
public int eval(str txt) = eval(parse(#Exp, txt));                

public int eval((Exp)`<IntegerLiteral l>`) = toInt("<l>");        
public int eval((Exp)`<Exp e1>*<Exp e2>`) = eval(e1) * eval(e2);  
public int eval((Exp)`<Exp e1>+<Exp e2>`) = eval(e1) + eval(e2);  
public int eval((Exp)`(<Exp e>)`) = eval(e);                  
