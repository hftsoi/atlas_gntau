asetup Athena,24.0.77
lsetup git
git atlas init-workdir https://:@gitlab.cern.ch:8443/atlas/athena.git -p TrigTauRec TrigTauMonitoring TrigOutputHandling TrigEDMConfig TriggerMenuMT
cd athena
git fetch upstream
git checkout -b base release/24.0.77
git remote add jy https://gitlab.cern.ch/jbeaucam/athena.git 
git fetch jy
git checkout -b new jy/24.0.77-hlt-gntau
git diff --stat base..new
cd ..
mkdir build
cd build
cmake ../athena/Projects/WorkDir
source ./x86_64-el9-gcc13-opt/setup.sh
make -j8
cd ..
mkdir local
cd local
cp -r /eos/user/j/jbeaucam/Trigger/TauTrigger/HLTGNTau/GNTau_config ./

export ATHENA_CORE_NUMBER=8

# mc23e
Reco_tf.py --CA --multithreaded=True --conditionsTag="OFLCOND-MC23-SDR-RUN3-05-03" \
--geometryVersion="ATLAS-R3S-2021-03-02-00" --autoConfiguration "everything" \
--preExec "all:flags.Trigger.AODEDMSet=\"AODFULL\"; flags.Jet.WriteToAOD=True; \
flags.MET.WritetoAOD=True; flags.Trigger.triggerMenuSetup=\"Dev_pp_run3_v1_TriggerValidation_prescale\"; \
from AthenaMonitoring.DQConfigFlags import allSteeringFlagsOff; allSteeringFlagsOff(flags); \
flags.DQ.Steering.doHLTMon=True; flags.DQ.Steering.HLT.doTau=True; flags.DQ.Steering.doDataFlowMon=True" \
--preInclude "all:Campaigns.MC23e" --postInclude "PyJobTransforms.UseFrontier" --steering "doRDO_TRIG" \
--inputRDOFile /scratch/htsoi/group.trig-analysis/group.trig-analysis.43031383.EXT0._000065.RDO.pool.root.1 \
--outputAODFile out.AOD.root --outputHISTFile out.HIST.root --maxEvents 50

# tarball creation
pathena --trf " " --noSubmit --outDS user."$USER".noOutput --noOutput --outTarBall=tarball.tgz --extFile GNTau_config GNTau_config/*.onnx GNTau_config/*.root

# eb data24
Trig_reco_tf.py --CA --autoConfiguration everything --ignoreErrors False --beamType collisions \
--athenaopts="all:--imf --threads=8 --concurrent-events=8 --nprocs=1" \
--conditionsTag="CONDBR2-BLKPA-2024-03" --geometryVersion="ATLAS-R3S-2021-03-02-00" \
--preExec "BSRDOtoRAW:Trigger.triggerMenuSetup=\"Dev_pp_run3_v1_TriggerValidation_prescale\" \
Trigger.doLVL1=True Trigger.L1MuonSim.NSWVetoMode=False Trigger.L1MuonSim.doMMTrigger=False \
Trigger.L1MuonSim.doPadTrigger=False Trigger.L1MuonSim.doStripTrigger=False" \
"RAWtoALL:flags.Trigger.triggerMenuSetup=\"Dev_pp_run3_v1_TriggerValidation_prescale\"; \
flags.Trigger.AODEDMSet=\"AODFULL\"; flags.Jet.WriteToAOD=True; flags.MET.WritetoAOD=True; \
from AthenaMonitoring.DQConfigFlags import allSteeringFlagsOff; allSteeringFlagsOff(flags); \
flags.DQ.Steering.doHLTMon=True; flags.DQ.Steering.HLT.doBjet=False; flags.DQ.Steering.HLT.doInDet=False; \
flags.DQ.Steering.HLT.doBphys=False; flags.DQ.Steering.HLT.doCalo=False; \
flags.DQ.Steering.HLT.doEgamma=False; flags.DQ.Steering.HLT.doJet=False; \
flags.DQ.Steering.HLT.doMET=False; flags.DQ.Steering.HLT.doMinBias=False; \
flags.DQ.Steering.HLT.doMuon=False; flags.DQ.Steering.HLT.doTau=True; \
flags.DQ.Steering.doGlobalMon=False; flags.DQ.Steering.doLVL1CaloMon=False; \
flags.DQ.Steering.doDataFlowMon=True; flags.DQ.Steering.doLVL1InterfacesMon=False; \
flags.DQ.Steering.doCTPMon=False;" --triggerConfig="all=FILE" --costopts="all:--useEBWeights=True" \
--inputBS_RDOFile /scratch/htsoi/data24_13p6TeV/data24_13p6TeV.00482596.physics_EnhancedBias.merge.RAW._lb0342._SFO-18._0001.1 \
--outputHIST_HLTMONFile output.HIST_HLTMON.root --outputNTUP_TRIGCOSTFile output.NTUP_TRIGCOST.root \
--outputAODFile output.AOD.root --outputNTUP_TRIGRATEFile output.NTUP_TRIGRATE.root \
--outputHISTFile output.HIST.root --maxEvents 200
