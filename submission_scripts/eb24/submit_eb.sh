pathena --trf='Trig_reco_tf.py --CA --autoConfiguration everything --ignoreErrors False --beamType collisions \
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
--inputBS_RDOFile %IN \
--outputHIST_HLTMONFile %OUT.HIST_HLTMON.pool.root.1 --outputNTUP_TRIGCOSTFile %OUT.NTUP_TRIGCOST.pool.root.1 \
--outputAODFile %OUT.AOD.pool.root.1 --outputNTUP_TRIGRATEFile %OUT.NTUP_TRIGRATE.pool.root.1 \
--outputHISTFile %OUT.HIST.pool.root.1' \
--nCore 2 --noEmail --nFilesPerJob 8 --inOutDsJson jobs_datasets_eb.json --dumpJson jobs_submit_eb.json \
--inTarBall tarball.tgz --nFiles 120
