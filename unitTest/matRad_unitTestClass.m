
classdef matRad_unitTestClass < matlab.unittest.TestCase
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% class definition for the unit tests of matRad
% 
% call over matRad_unitTestTAP to create a .tap output file
%  suite = TestSuite.fromClass(?matRad_unitTestClass)
%
% call with specific parameter value after :
%  newsuite = suite.selectIf('ParameterName','Value');
%
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% Copyright 2015, Mark Bangert, on behalf of the matRad development team
%
% m.bangert@dkfz.de
%
% This file is part of matRad.
%
% matrad is free software: you can redistribute it and/or modify it under 
% the terms of the GNU General Public License as published by the Free 
% Software Foundation, either version 3 of the License, or (at your option)
% any later version.
%
% matRad is distributed in the hope that it will be useful, but WITHOUT ANY
% WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE. See the GNU General Public License for more
% details.
%
% You should have received a copy of the GNU General Public License in the
% file license.txt along with matRad. If not, see
% <http://www.gnu.org/licenses/>.
%
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    properties (TestParameter)
        % definition of relevant parameters for the test
        radiationMode = struct{
        patient = {'BOXPHANTOM'};
    end
    
    methods(Test)
        % test dose calculation for the given parameters
        function doseCalculation(testCase,patient,radiationMode,bioOptimazation)
            pln.
            % load cst
                
            stf = matRad_generateStf(ct,cst,pln);
            if strcmp(pln.radiationMode,'photons')
               dij = matRad_calcPhotonDose(ct,stf,pln,cst,0);
            elseif  strcmp(pln.radiationMode,'protons') || ...
                    strcmp(pln.radiationMode,'carbon')
                    dij = matRad_calcParticleDose(ct,stf,pln,cst,0);
            end
    
        end
        
    end
end

