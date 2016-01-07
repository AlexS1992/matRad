
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
        patient = {'BOXPHANTOM'};
        SAD = {500,1000};
        bixelWidth = {3,5}; 
        gantryAngles = {0,120,240};
        couchAngles = {0,5};
        bioOptimization = {'none','effect','RBExD'};
        numOfFractions = {1,10,20};
        runSequencing = {0,1};
        runDAO = {0,1};
        stratification = {7,20};
    end
    
    methods(Test)
        % test photon plan
        function photonPlan(testCase,patient,SAD,bixelWidth,gantryAngles,couchAngles,...
                            runSequencing,runDAO,stratification)
            % set pln
            pln.patient = patient;
            pln.SAD = SAD;
            pln.bixelWidth = bixelWidth;
            pln.gantryAngles = gantryAngles;
            pln.couchAngles = couchAngles;
            pln.runSequencing = runSequencing;
            pln.runDAO = runDAO;
            
            % load patient data and generate stf
            load(pln.patient);
            stf = matRad_generateStf(ct,cst,pln);
            
            % dose calculation
            dij = matRad_calcPhotonDose(ct,stf,pln,cst);
            
            % sequecing
            if strcmp(pln.radiationMode,'photons') && (pln.runSequencing || pln.runDAO)
                resultGUI = matRad_engelLeafSequencing(resultGUI,stf,dij,stratification);
            end
            
            % DAO
            if strcmp(pln.radiationMode,'photons') && pln.runDAO
                resultGUI = matRad_directApertureOptimization(dij,cst,resultGUI.apertureInfo,resultGUI);
            end
            
        end
    end
        
end
  
