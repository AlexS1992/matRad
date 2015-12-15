% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% unitTest script for call from Jenkins to create the .tap output
% 
% call to create a .tap output file
%  suite = TestSuite.fromClass(?matRad_unitTestClass)
%
% call with specific parameter value after creation of a test suite:
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
import matlab.unittest.TestRunner
import matlab.unittest.TestSuite
import matlab.unittest.plugins.TAPPlugin
import matlab.unittest.plugins.ToFile

%create test suite
suite   = TestSuite.fromClass(?matRad_unitTestClass);

%create runner for output
runner = TestRunner.withTextOutput;

%define output
tapFile = 'matRad_unitTest.tap';

%delete old output
if exist(tapfile,'file')== 2
delete(tapFile);
end

%define output stream
plugin = TAPPlugin.producingOriginalFormat(ToFile(tapFile));

%run the suite
runner.addPlugin(plugin)
result = runner.run(suite);

%view in matlab
%disp(fileread(tapFile))

copyfile(tapFile, X);
%%
exit;
