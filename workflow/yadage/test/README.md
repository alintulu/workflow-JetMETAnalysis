## Test showcasing scatter-gather paradigm and subworkflows

### Workflow

```
yadage-run workdir workflow.yaml inputs_less.yaml
```

The file workflow.yaml first calls the subworkflow.yaml. The subworkflow runs as a multistep-stage
with batchsize 5, meaning that N number of jobs are created, each job having as input 5 files read from
inputs_less.yaml.

[Start subworkflow...Creating N jobs and each jobs performs:]
1. Run creation of PU ntuples and noPU ntuples independently of eachother
2. Runs list_lumi for PU when previous step for PU is done, same for noPU

[End subworkflow...When all N jobs are done]

3. Gather the output from the both PU and noPU list_lumi steps of the subworkflow
4. Run match_files on the output

### Structure

The file [workflow.yaml](workflow.yaml) contains two stages
* `map`
  * Scattering paradigm, i.e. runs jobs in parallel
  * Refers to a subworkflow, [see line](https://github.com/alintulu/reana-demo-JetMETAnalysis/blob/master/workflow/yadage/test/workflow.yaml#L10)
* `reduce`
  * Runs in a single step
  * Gets its input from the previous step `map`, specifically from the substeps `list_lumi_PU`
  and `list_lumi_noPU`
  
The file [subworkflow.yaml](subworkflow.yaml) contains four stages
* `ntuple_PU` runs independently
* `ntuple_noPU` runs independently
* `list_lumi_PU` depend on `ntuple_PU`
* `list_lumi_noPU` depend on `ntuple_noPU`

The file [steps.yaml](steps.yaml) contains three processes
* `ntuple` creates ntuples out of root files
* `list_lumi` outputs a text files containing information of every lumisection,
which run it belongs to and in which root file it can be found
* `match_files` outputs a text file of every lumisection and which PU and noPU
file it can be found in



