# DiskJockeyTests

[![Build Status](https://github.com/iancze/DiskJockeyTests.jl/workflows/CI/badge.svg)](https://github.com/iancze/DiskJockeyTests.jl/actions)


# Usage 

    julia> ]
    pkg> activate . 
    pkg> test

## Rationale
In version 0.16 of DiskJockey, I made the decision to split the testing into two places: small tests for the core functionality in the package itself, and larger script, parallel, or data intensive tests here. Because DiskJockey is a computation and data intensive program, it is difficult to functionally test every aspect of the program quickly and still have it run under continuous integration. 

Within the main DiskJockey package are those tests that can be done quickly and are limited to testing the code within `src/` (i.e., not testing scripts/). As of 6/2020, there are still many areas within `src/` that could use more tests.

The idea for this testing package is twofold. First, it is designed to test the scripting and interactive component of DiskJockey, such as the `Makefile` interface. Second, it is designed to be run in a cluster environment, most likely interactively, to test the `venus.jl` inference and driver script. It is designed to catch the kind of bug that you only discover after queuing for cores for several hours.
