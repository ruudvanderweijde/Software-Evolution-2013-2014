@license{
  Copyright (c) 2009-2013 CWI
  All rights reserved. This program and the accompanying materials
  are made available under the terms of the Eclipse Public License v1.0
  which accompanies this distribution, and is available at
  http://www.eclipse.org/legal/epl-v10.html
}
module demo::visualization::InteractiveBoxHeight

import vis::Figure;
import vis::Render;

public bool intInput(str s){
	return /^[0-9]+$/ := s;
}

public Figure higher(){
	int H = 100;
    return vcat( [ textfield("<H>", void(str s){H = toInt(s);}, intInput),
	               box(width(100), vresizable(false), vsize(num(){return H;}), fillColor("red"))
	             ], shrink(0.5), resizable(false));
}