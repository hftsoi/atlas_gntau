ssh pc-tbed-tpu-05010 05011 05012
cd /dsk1/tmp/
mkdir htsoi
cd htsoi
setupATLAS ;lsetup rucio;lsetup git ;sh /afs/cern.ch/work/h/htsoi/cert.sh
rucio download data24_13p6TeV:data24_13p6TeV.00482596.physics_EnhancedBias.merge.RAW._lb0259._SFO-ALL._0001.1

export ATHENA_CORE_NUMBER={< total number of cores in the node}

asetup --restore
source ./x86_64-el9-gcc13-opt/setup.sh

cp -r /eos/user/j/jbeaucam/Trigger/TauTrigger/HLTGNTau/GNTau_config ./

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
--inputBS_RDOFile /dsk1/tmp/htsoi/data24_13p6TeV/data24_13p6TeV.00482596.physics_EnhancedBias.merge.RAW._lb0259._SFO-ALL._0001.1 \
--outputHIST_HLTMONFile output.HIST_HLTMON.root \
--outputNTUP_TRIGCOSTFile output.NTUP_TRIGCOST.root

CostAnalysisPostProcessing.py --file output.NTUP_TRIGCOST.root
