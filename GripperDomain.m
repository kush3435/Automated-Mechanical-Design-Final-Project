%----------------------------------------------  DEFINE DOMAIN
function [x] = GripperDomain(Demand,Arg)
  BdBox = [0 6 0 6];
  switch(Demand)
    case('Dist');  x = DistFnc(Arg,BdBox);
    case('BC');    x = BndryCnds(Arg{:},BdBox);
    case('BdBox'); x = BdBox;
    case('PFix');  x = FixedPoints(BdBox);
  end
%----------------------------------------------- COMPUTE DISTANCE FUNCTIONS
function Dist = DistFnc(P,BdBox)
  d1 = dRectangle(P,BdBox(1),BdBox(2),BdBox(3),BdBox(4));
 d2 = dRectangle(P,BdBox(1)+5,BdBox(2),BdBox(3)+2.4,3.6);
   Dist = dDiff(d1,d2);
% %---------------------------------------------- SPECIFY BOUNDARY CONDITIONS
function [x] = BndryCnds(Node,Element,BdBox)
  eps = 0.1*sqrt((BdBox(2)-BdBox(1))*(BdBox(4)-BdBox(3))/size(Node,1));
  LeftEdgeNodes_lower = find(abs(Node(:,1)-BdBox(1))<eps & abs(Node(:,2))<0.6);
  LeftEdgeNodes_upper = find(abs(Node(:,1)-BdBox(1))<eps & abs(Node(:,2))>5.4);
%   LeftEdgeNodes = find(abs(Node(:,1)-BdBox(1))<eps)
  RigthLoadNode_lower = find(abs(Node(:,1)-BdBox(2))<eps & ...
                         abs(Node(:,2)-2.4)<eps);
  RigthLoadNode_upper = find(abs(Node(:,1)-BdBox(2))<eps & ...
                         abs(Node(:,2)-3.6)<eps);
  LeftLoadNode = find(abs(Node(:,1)-BdBox(1))<eps & ...
                         abs(Node(:,2))<3.00 & abs(Node(:,2))>2.88);
  Load = zeros(length(LeftLoadNode),3);
  Load(:,3) = 0.3; Load(:,1)=LeftLoadNode;  Load(:,2) = 1;
  supps = [LeftEdgeNodes_upper; LeftEdgeNodes_lower];
  Supp = ones(size(supps,1),3);
%   Supp = zeros(length(FixedNodes),3);
  Supp(:,1)=supps;
  Load = [Load; RigthLoadNode_lower,0,0.35 ; RigthLoadNode_upper,0,-0.35];  
  x = {Supp,Load};
%---------------------------------------------- SPECIFY BOUNDARY CONDITIONS
% function [x] = BndryCnds(Node,Element,BdBox)
%   eps = 0.1*sqrt((BdBox(2)-BdBox(1))*(BdBox(4)-BdBox(3))/size(Node,1));
%   LeftEdgeNodes = find(abs(Node(:,1)-BdBox(1))<eps);
%   LeftUpperNode = find(abs(Node(:,1)-BdBox(1))<eps & ...
%                        abs(Node(:,2)-BdBox(4))<eps);
%   RigthBottomNode = find(abs(Node(:,1)-BdBox(2))<eps & ...
%                          abs(Node(:,2)-BdBox(3))<eps);
%  
% %   FixedNodes = [LeftEdgeNodes;RigthBottomNode];
%   FixedNodes = [LeftEdgeNodes;RigthBottomNode];
%   Supp = zeros(length(FixedNodes),3);
%   Supp(:,1)=FixedNodes; Supp(1:end-1,2)=1; Supp(end,3)=1;
%   Load = [LeftUpperNode,0,0.5];
%   x = {Supp,Load};
%-----------------------------------
% %----------------------------------------------------- SPECIFY FIXED POINTS
function [PFix] = FixedPoints(BdBox)
  PFix = [];
%------------------%-------------------------------------------------------%