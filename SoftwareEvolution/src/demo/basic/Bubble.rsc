module demo::basic::Bubble

import List;
import IO;

// Variations on Bubble sort

// sort1: uses list indexing and a for-loop

public list[int] sort1(list[int] Numbers){
  for(int I <- [0 .. size(Numbers) - 1]){
     if(Numbers[I] > Numbers[I+1]){
       <Numbers[I], Numbers[I+1]> = <Numbers[I+1], Numbers[I]>;
       return sort1(Numbers);
     }
  }
  return Numbers;
}

// sort2: uses list matching and switch

// changed list[int] Nums1 to *Nums1
// changed list[int] Nums2 to *Nums2

public list[int] sort2(list[int] Numbers){
  switch(Numbers){
    case [*Nums1, int P, int Q, *Nums2]:
       if(P > Q){
          return sort2(Nums1 + [Q, P] + Nums2);
       } else {
       	  fail;
       }
     default: return Numbers;
   }
}
// sort3: uses list matching and while

// changed list[int] Nums1 to *Nums1
// changed list[int] Nums2 to *Nums2
// changed list[int] Nums3 to *Nums3

public list[int] sort3(list[int] Numbers){
  while([*Nums1, int P, *Nums2, int Q, *Nums3] := Numbers && P > Q)
        Numbers = Nums1 + [Q] + Nums2 + [P] + Nums3;
  return Numbers;
}

// sort4: similar to sort3, but shorter.

public list[int] sort4(list[int] Numbers){
  while([Nums1*, P, Nums2*, Q, Nums3*] := Numbers && P > Q)
        Numbers = Nums1 + [Q] + Nums2 + [P] + Nums3;
  return Numbers;
}


// sort5: using recursion instead of iteration, and splicing instead of concat
public list[int] sort5([*Nums1, int P, *Nums2, int Q, *Nums3]) {
  if (P > Q) 
    return sort5([*Nums1, Q, *Nums2, P, *Nums3]); 
  else 
    fail sort5;
}

public default list[int] sort5(list[int] x) = x;

// finally, sort 6 inlines the condition into a when:
public list[int] sort6([*Nums1, int P, *Nums2, int Q, *Nums3]) 
  = sort6([*Nums1, Q, *Nums2, P, *Nums3])
  when P > Q; 

public default list[int] sort6(list[int] x) = x;