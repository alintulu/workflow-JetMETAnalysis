
```console
export DATASET=/QCD_Pt-15to7000_TuneCP5_Flat2018_13TeV_pythia8/RunIIAutumn18DR-FlatPU0to70RAW_102X_upgrade2018_realistic_v15-v1/AODSIM
dasgoclient -query="file dataset=$DATASET" -json | jq . > input_PU.json
```

```console
export DATASET=/QCD_Pt-15to7000_TuneCP5_Flat2018_13TeV_pythia8/RunIIAutumn18DR-NoPU_102X_upgrade2018_realistic_v15-v1/AODSIM
dasgoclient -query="file dataset=$DATASET" -json | jq . > input_noPU.json
```

```console
python get_files_dasgoclient.py
```

>Input: input_PU.json, input_noPU.json
>
>Output: inputs.yaml


