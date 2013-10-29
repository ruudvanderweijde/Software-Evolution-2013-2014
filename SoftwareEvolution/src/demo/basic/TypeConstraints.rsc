module demo::basic::TypeConstraints

import Number;
import Node;

public &T <: num abs(&T <: num N)
{
	return N >= 0 ? N : -N;
}

data Suite = hearts() | diamonds() | clubs() | spades();