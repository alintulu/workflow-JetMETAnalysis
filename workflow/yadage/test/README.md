## Test showcasing scatter-gather paradigm and subworkflows

```
yadage-run workdir workflow.yaml inputs_less.yaml
```

Why subworkflows? You can define an entire workflow to run as a single step in another workflow! Converting a two step workflow to a single step subworkflow.

The file workflow.yaml starts by calling subworkflow.yaml. The subworkflow defines two unique steps, the second depending on the first. The second step expects as input a file from the first step, it will wait until everything in step one is finished before starting.

The subworkflow is called as a multistep-stage meaning that N number of jobs are created for the first step, each job having a unique input read from `inputs_less.yaml`. Without a subworfklow the second step would have to wait until all N jobs are done in step one, despite only depending on the output from one of those jobs. Fortunately with a subworkflow, scattering on steps can proceed independently. This mean that when job 5 is done with step one (create ntuple) it can continue to step two (list lumi sections) without having to wait for job 4 (or any other job) to finish step one.

To see what I mean:

[Start the workflow]

* input: text file containing N names of root files 

[Start subworkflow...creating N jobs, all jobs running parallel, each job performing]

1. Run creation of PU ntuples and noPU ntuples independently of eachother
 * input: one name of root file
 * output: one ntuple root file
2. Runs list_lumi for PU when previous step for PU is done, same for noPU
 * input: one ntuple root file created in previous step
 * output: one text file containing information of every lumisection in the ntuple

[End subworkflow...when all N jobs are done for step two]

* output: N ntuple root files
* output: N text files containing information of every lumisection in the ntuple sample

3. Gather the output from both PU and noPU step two of the subworkflow
4. Run match_files on the output
 * input: N text files containing information of every lumisection in the ntuple sample
 * output: one text file with every lumisection and which PU and noPU
ntuple root file it can be found in

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


----------------------------------------

```

---------------------
| Ntuple production |   Running parallel
---------------------
   |      |      |    
  ------  |  --------
  | PU |  |  | NoPU |
  ------  |  --------   
   |      |      |
   v      v      v
---------------------
| List lumisections |   Running parallel
---------------------
   |      |      |    
  ------  |  --------
  | PU |  |  | NoPU |
  ------  |  --------   
   |      |      |
   v      v      v
-----------------------
| Match lumi PU & noPU|   Single process
-----------------------
         |
         |
         v
------------------
|   Match jets   |   Running parallel
------------------
  |      |      |    
  |      |      |
  v      v      v             <-- hadd
---------------------------  
| Compute L1  corrections |   Single process -> Output: L1 corrections
---------------------------
         |
         |
         v
------------------------
| Apply L1 corrections |   Running parallel
------------------------
  |      |      |    
  |      |      |
  v      v      v
-----------------------------------------------------
| Produce histograms (for higher level corrections) |   Running parallel
-----------------------------------------------------
  |      |      |    
  |      |      |
  |      |      |               
  |      |      |    hadd   -----------------------------   
  x------x------x---------> | Compute L2L3  corrections |   Single process -> Output: L2L3 corrections
  |      |      |           -----------------------------
  |      |      |                            
  v      v      v                                                            
------------------------
| Compute Closure files |   Running parallel
------------------------
  |      |      |    
  |      |      |
  v      v      v
----------------------
|  Draw Closure plots |   Single process
-----------------------
        |
        |
        v
      DONE
      -> Output: Closure plots

Output: 
- Text file of L1 corrections
- Text file of L2L3 corrections
- Closure plots
```
