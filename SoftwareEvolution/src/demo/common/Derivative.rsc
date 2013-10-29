module demo::common::Derivative

data Exp = con(int n)           
         | var(str name)
         | mul(Exp e1, Exp e2)
         | add(Exp e1, Exp e2)
         ;
         
public Exp E = add(mul(con(3), var("y")), mul(con(5), var("x"))); 

public Exp dd(con(n), var(V))              = con(0);  
public Exp dd(var(V1), var(V2))            = con((V1 == V2) ? 1 : 0);
public Exp dd(add(Exp e1, Exp e2), var(V)) = add(dd(e1, var(V)), dd(e2, var(V)));
public Exp dd(mul(Exp e1, Exp e2), var(V)) = add(mul(dd(e1, var(V)), e2), mul(e1, dd(e2, var(V))));
 

public Exp simp(add(con(n), con(m))) = con(n + m);   
public Exp simp(mul(con(n), con(m))) = con(n * m);

public Exp simp(mul(con(1), Exp e))  = e;
public Exp simp(mul(Exp e, con(1)))  = e;
public Exp simp(mul(con(0), Exp e))  = con(0);
public Exp simp(mul(Exp e, con(0)))  = con(0);

public Exp simp(add(con(0), Exp e))  = e;
public Exp simp(add(Exp e, con(0)))  = e;

public default Exp simp(Exp e)       = e;            

public Exp simplify(Exp e){                          
  return bottom-up visit(e){
           case Exp e1 => simp(e1)
         }
}