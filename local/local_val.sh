asetup Athena,24.0,latest
lsetup git
git atlas init-workdir https://:@gitlab.cern.ch:8443/atlas/athena.git -p TrigTauRec TrigTauMonitoring TrigOutputHandling TrigEDMConfig TriggerMenuMT
cd athena
git fetch upstream
git checkout -b new upstream/24.0
git checkout -b new2
git fetch https://gitlab.cern.ch/jbeaucam/athena.git a86d767928a0e3070329f0e301b5ba3b7e057a6e
git cherry-pick a86d767928a0e3070329f0e301b5ba3b7e057a6e
git diff --stat new..new2
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

Reco_tf.py --CA --athenaopts="all:--threads=8 --concurrent-events=8 --nprocs=1" --conditionsTag="OFLCOND-MC23-SDR-RUN3-05-03" \
--geometryVersion="ATLAS-R3S-2021-03-02-00" --autoConfiguration "everything" --preExec "all:flags.Trigger.AODEDMSet=\"AODFULL\"; \
flags.Jet.WriteToAOD=True; flags.MET.WritetoAOD=True; flags.Trigger.triggerMenuSetup=\"Dev_pp_run3_v1_TriggerValidation_prescale\"; \
from AthenaMonitoring.DQConfigFlags import allSteeringFlagsOff; allSteeringFlagsOff(flags); flags.DQ.Steering.doHLTMon=True; \
flags.DQ.Steering.HLT.doTau=True; flags.DQ.Steering.doDataFlowMon=True" --preInclude "all:Campaigns.MC23e" \
--postInclude "PyJobTransforms.UseFrontier" --steering "doRDO_TRIG" \
--inputRDOFile /scratch/htsoi/group.trig-analysis/group.trig-analysis.41590967.EXT0._000052.RDO.pool.root.1 \
--outputAODFile out.AOD.root --outputHISTFile out.HIST.root --maxEvents 100
