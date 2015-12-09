function matRad_bystCall(patientID,pln)


% profile on
%%
[ct,cst] = matRad_importVirtuosDataSet(patientID,0);

%%
if nargin == 1
    pln.SAD             = 10000; %[mm]
    pln.isoCenter       = matRad_getIsoCenter(cst,ct,0);
    pln.bixelWidth      = 5; % [mm] / also corresponds to lateral spot spacing for particles
    pln.gantryAngles    = [30]; % [°]
    pln.couchAngles     = [0]; % [°]
    pln.radiationMode   = 'protons'; % either photons / protons / carbon
    pln.bioOptimization = 'none'; % none: physical optimization; effect: effect-based optimization; RBExD: optimization of RBE-weighted dose
    pln.numOfFractions  = 30;
    pln.runSequencing   = false; % 1/true: run sequencing, 0/false: don't / will be ignored for particles and also triggered by runDAO below
    pln.runDAO          = false; % 1/true: run DAO, 0/false: don't / will be ignored for particles
else
    load(pln)
    if ~isfield(pln, 'isoCenter')
        pln.isoCenter = matRad_getIsoCenter(cst,ct,0);
    end
end

pln.numOfBeams      = numel(pln.gantryAngles);
pln.numOfVoxels     = numel(ct.cube);
pln.voxelDimensions = size(ct.cube);

%% generate steering file
stf = matRad_generateStf(ct,cst,pln);

%% dose calculation
if strcmp(pln.radiationMode,'photons')
    dij = matRad_calcPhotonDose(ct,stf,pln,cst);
elseif strcmp(pln.radiationMode,'protons') || strcmp(pln.radiationMode,'carbon')
    dij = matRad_calcParticleDose(ct,stf,pln,cst);
end

%% inverse planning for imrt
resultGUI = matRad_fluenceOptimization(dij,cst,pln);

%%
matRad_writeVirtousDose(resultGUI,ct,[patientID 'xxx'])

exit
%%
%profile off
%profile viewer