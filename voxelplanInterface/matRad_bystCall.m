function matRad_bystCall(patientID,pln)


% profile on
%%
[ct,cst] = matRad_importVirtuosDataSet(patientID,0);

%%
load(pln)

if ~isfield(pln, 'isoCenter')
    pln.isoCenter = matRad_getIsoCenter(cst,ct,0);
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