module demo::basic::Functions

rel[int, int] invert(rel[int,int] R){
	return {<Y, X> | <int X, int Y> <- R };
}

//invert({<1,10>, <2,20>});
//
//rel[int,int]: {
//  <20,2>,
//  <10,1>
//}

rel[&T2, &T1] invert2(rel[&T1,&T2] R){  
   return {<Y, X> | <&T1 X, &T2 Y> <- R };
}

// insert2 werkt niet voor <"mon",1> etc

data B = t() | f() | neg(B);
