# sample data organization 

## MPM Data BIDS input  

The below tree shows a typical folder organisation of a MPM data organization in BIDS. 


```
UCL/
├── sub-UCL001
│   ├── ses-01
│   │   ├── anat
│   │   ├── fmap
│   │   └── shim
│   └── ses-02
│       ├── anat
│       ├── fmap
│       └── shim
└── sub-UCL002
    └── ses-01
        ├── anat
        ├── fmap
        └── shim
```


## MPM processed data - eg hMRI toolbox - BIDS output

The tree shows output organization of MPM data. In this example, each sessiom had two acquisition scan and rescan. scan and recan folders are created inside session folder. MPM mpas are created for each acquistion using hMRI toolbox. 

This folder should maintain the following oragnization. 

**AutoReorient** (output folder for hMRI reorient) and hMRI-output folder (in this case **acq_B1_LowFA** ).  

The  hMRI-output folder shouls have thes folders 

**Results** - output of hMRI

**segment-TEzero** - segment using the TEZero image

**Results_USnorm** - normized images in MNI (this coudl be USnorm or DARTELnorm)

Optional folder 
**MPMCalc,RFsensCalc,skullstrip**


```
UCL/
├── sub-UCL001
│   ├── ses-01
│   │   ├── rescan
│   │   │   ├── acq_B1_LowFA
│   │   │   │   ├── B1mapCalc
│   │   │   │   ├── batch_hmri_map_UCL_acq_B1_LowFA_sub-UCL001-ses-01_rescan_job.m
│   │   │   │   ├── MPMCalc
│   │   │   │   ├── Results
│   │   │   │   ├── Results_USnorm
│   │   │   │   ├── RFsensCalc
│   │   │   │   ├── segment_TEzero
│   │   │   │   └── skullstrip
│   │   │   ├── AutoReorient
│   │   │   └── batch_autoreor_UCL_sub-UCL001-ses-01_rescan_job.m
│   │   └── scan
│   │       ├── acq_B1_LowFA
│   │       │   ├── B1mapCalc
│   │       │   ├── batch_hmri_map_UCL_acq_B1_LowFA_sub-UCL001-ses-01_scan_job.m
│   │       │   ├── MPMCalc
│   │       │   ├── Results
│   │       │   ├── Results_USnorm
│   │       │   ├── RFsensCalc
│   │       │   ├── segment_TEzero
│   │       │   └── skullstrip
│   │       ├── AutoReorient
│   │       └── batch_autoreor_UCL_sub-UCL001-ses-01_scan_job.m
│   └── ses-02
│       └── scan
│           ├── acq_B1_LowFA
│           │   ├── B1mapCalc
│           │   ├── batch_hmri_map_UCL_acq_B1_LowFA_sub-UCL001-ses-02_scan_job.m
│           │   ├── MPMCalc
│           │   ├── Results
│           │   ├── Results_USnorm
│           │   ├── RFsensCalc
│           │   ├── segment_TEzero
│           │   └── skullstrip
│           ├── AutoReorient
│           └── batch_autoreor_UCL_sub-UCL001-ses-02_scan_job.m   
└── sub-UCL002
    └── ses-01
        ├── rescan
        │   ├── acq_B1_LowFA
        │   │   ├── B1mapCalc
        │   │   ├── batch_hmri_map_UCL_acq_B1_LowFA_sub-UCL002-ses-01_rescan_job.m
        │   │   ├── MPMCalc
        │   │   ├── Results
        │   │   ├── Results_USnorm
        │   │   ├── RFsensCalc
        │   │   ├── segment_TEzero
        │   │   └── skullstrip
        │   ├── AutoReorient
        │   └── batch_autoreor_UCL_sub-UCL002-ses-01_rescan_job.m
        └── scan
            ├── acq_B1_LowFA
            │   ├── B1mapCalc
            │   ├── batch_hmri_map_UCL_acq_B1_LowFA_sub-UCL002-ses-01_scan_job.m
            │   ├── MPMCalc
            │   ├── Results
            │   ├── Results_USnorm
            │   ├── RFsensCalc
            │   ├── segment_TEzero
            │   └── skullstrip
            ├── AutoReorient
            └── batch_autoreor_UCL_sub-UCL002-ses-01_scan_job.m
```




