## Test showcasing scatter-gather paradigm and subworkflows

```
yadage-run workdir workflow.yaml inputs_less.yaml
```

Why subworkflows? You can define an entire workflow to run as a single step in another workflow! Converting a two step workflow to a single step subworkflow.

The file workflow.yaml starts by calling subworkflow.yaml. The subworkflow defines two unique steps, the second depending on the first. The second step expects as input a file from the first step, it will wait until everything in step one is finished before starting.

The subworkflow is called as a multistep-stage meaning that N number of jobs are created for the first step, each job having a unique input read from `inputs_less.yaml`. Without a subworfklow the second step would have to wait until all N jobs are done in step one, despite only depending on the output from one of those jobs. Fortunately with a subworkflow, scattering on steps can proceed independently. This mean that when job 5 is done with step one (create ntuple) it can continue to step two (list lumi sections) without having to wait for job 4 (or any other job) to finish step one.

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
  v      v      v         <-- hadd
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

