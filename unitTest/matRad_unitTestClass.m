
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
        pln = struct('Plan1',struct('patient','BOXPHANTOM','bixelWidth',5,...
                                    'gantryAngles','0','couchAngles','0',...
                                    'radiationMode','photons','runDAO',0,...
                                    'testID','1'),...
                     'Plan2',struct('patient','BOXPHANTOM','bixelWidth',5,...
                                    'gantryAngles','0','couchAngles','0',...
                                    'radiationMode','photons','runDAO',1,...
                                    'testID','2'))
                     
                                
    end
    
    methods(Test)
        % test plan
        function testPlan(testCase,pln)
            % load reference data
            load(['matRad_referenceFile_' pln.testID '.mat']);
            
            % load patient data 
            load(pln.patient);
            
            % set rest of pln
            pln.isoCenter       = matRad_getIsoCenter(cst,ct);
            pln.numOfBeams      = numel(pln.gantryAngles);
            pln.numOfVoxels     = numel(ct.cube);
            pln.voxelDimensions = size(ct.cube);
            pln.machine         = 'Generic';
                
            % generate steering file
            stf = matRad_generateStf(ct,cst,pln);

            %% dose calculation
            if strcmp(pln.radiationMode,'photons')
                dij = matRad_calcPhotonDose(ct,stf,pln,cst);
            elseif strcmp(pln.radiationMode,'protons') || strcmp(pln.radiationMode,'carbon')
                    dij = matRad_calcParticleDose(ct,stf,pln,cst);
            end

            %% inverse planning for imrt
            resultGUI = matRad_fluenceOptimization(dij,cst,pln);

            %% sequencing
            if strcmp(pln.radiationMode,'photons')
                resultGUI = matRad_engelLeafSequencing(resultGUI,stf,dij,15);
            end

            %% DAO
            if strcmp(pln.radiationMode,'photons') && pln.runDAO
                resultGUI = matRad_directApertureOptimization(dij,cst,resultGUI.apertureInfo,resultGUI);
            end

            %% quality indicators
            resultGUI = matRad_calcQualityIndicators(resultGUI,cst);
            
            stats = matRad_verifyResultUnitTest(resultGUI_ref,resultGUI);
            
        end
    end
        
end
  
