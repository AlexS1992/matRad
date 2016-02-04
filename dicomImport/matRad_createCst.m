function cst = matRad_createCst(structures)
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% matRad function to create a cst struct upon dicom import
% 
% call
%   cst = matRad_createCst(structures)
%
% input
%   structures:     matlab struct containing information about rt structure
%                   set (generated with matRad_importDicomRtss and 
%                   matRad_convRtssContours2Indices)
%
% output
%   cst:            matRad cst struct
%
% References
%   -
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2016, Mark Bangert, on behalf of the matRad development team
%
% m.bangert@dkfz.de
%
% This file is part of matRad.
%
% matrad is free software: you can redistribute it and/or modify it under 
% the terms of the Eclipse Public License 1.0 (EPL-1.0).
%
% matRad is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE.
%
% You should have received a copy of the EPL-1.0 in the file license.txt
% along with matRad. If not, see <http://opensource.org/licenses/EPL-1.0>.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

cst = cell(size(structures,2),6);

for i = 1:size(structures,2)
    cst{i,1} = i - 1; % first organ has number 0    
    cst{i,2} = structures(i).structName;
    
    if ~isempty(regexpi(cst{i,2},'tv')) || ...
       ~isempty(regexpi(cst{i,2},'target')) || ...
       ~isempty(regexpi(cst{i,2},'gtv')) || ...
       ~isempty(regexpi(cst{i,2},'ctv')) || ...
       ~isempty(regexpi(cst{i,2},'ptv')) || ...
       ~isempty(regexpi(cst{i,2},'boost')) || ...
       ~isempty(regexpi(cst{i,2},'tumor'))
        cst{i,3} = 'TARGET';
        % default objectives for targets
        cst{i,6}(1).parameter = [800 60]; %  
        cst{i,6}(1).type = 'square deviation';
        cst{i,5}.Priority = 1;
    else
        cst{i,3} = 'OAR';
        cst{i,6} = []; % define no OAR dummy objcetives   
        cst{i,5}.Priority = 2;
    end
    
    cst{i,4} = structures(i).indices;
    % set default parameter for biological planning
    cst{i,5}.TissueClass = 1; 
    cst{i,5}.alphaX = 0.1;
    cst{i,5}.betaX = 0.05;

end
