classdef element
  properties
    len
    cx
    cy
    EA
    EI
    S_M
    R
    nodes
    dof
  end
  methods
    function elem = element(EA, EI, node_1, node_2, nodes_no)
      elem.nodes = nodes_no;
      elem.dof = [3*nodes_no(1)-2:3*nodes_no(1), 3*nodes_no(2)-2:3*nodes_no(2)];
      elem.len = sqrt((node_2(1) - node_1(1))^2 + (node_2(2) - node_1(2))^2);
      elem.cx = (node_2(1) - node_1(1)) / elem.len;
      elem.cy = (node_2(2) - node_1(2)) / elem.len;
      elem.EA = EA;
      elem.EI = EI;
      k11 = EA/elem.len * elem.cx^2 + 12*EI / elem.len^3 * elem.cy^2;
      k21 = (EA / elem.len - 12*EI / elem.len^3) * elem.cx * elem.cy;
      k22 = EA/elem.len * elem.cy^2 + 12*EI/elem.len^3 * elem.cx^2;
      k31 = -6*EI / elem.len^2 * elem.cy;
      k32 = 6*EI / elem.len^2 * elem.cx;
      k33 = 4*EI / elem.len;
      elem.S_M = [k11, k21, k31, -k11, -k21, k31;
                  k21, k22, k32, -k21, -k22, k32;
                  k31, k32, k33, -k31, -k32, k33/2;
                  -k11, -k21, -k31, k11, k21, -k31;
                  -k21, -k22, -k32, k21, k22, -k32;
                  k31, k32, k33/2, -k31, -k32, k33];
      elem.R = [elem.cx, elem.cy, 0, 0, 0, 0;
                -elem.cy, elem.cx, 0, 0, 0, 0;
                0, 0, 1, 0, 0, 0;
                0, 0, 0, elem.cx, elem.cy, 0;
                0, 0, 0, -elem.cy, elem.cx, 0;
                0, 0, 0, 0, 0, 1];
    end
  end
end
