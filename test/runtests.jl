using DiskJockeyTests
using Test

##########################
# Project.toml management
##########################

# The goal of this package is to test the scripts environment of DiskJockey. 
# Because there are a lot of environments floating around, it makes sense 
# to describe them here. 

# 1) DiskJockeyTests.jl/Project.toml : the basic description for this package. 
# This package does nothing on its own, so this is essentially empty. 

# 2) DiskJockeyTests/test/Project.toml : this is the testing environment activated 
# when running `pkg> test`. The only packages we really need are Tests 
# for reasons explained in the next item.

# 3) outputdir/Project.toml : The design of the DiskJockey package is such that the user 
# creates a Julia environment to which they install DiskJockey. 
# Then, the add the `scripts/` directory to their system PATH so that they can run these 
# files easily.
# They should also set the environment variable `JULIA_PROJECT` to their environment 
# directory. We could also set it to "@."
# The scripts that go along with DiskJockey use other packages for reading configuration 
# files and for plotting. The user can either install these packages individually, or 
# use the DJ_initialize_environment.jl scirpt to install all of them directly.
# This project directory will contain the data, config, and output pertaining to that run. 


# The testing is designed to simulate this workflow.
# Check to see if an environment variable is defined. If so, save output there. 
outputdir = get(ENV, "JL_TEST_TEMPDIR", nothing)
if isnothing(outputdir)
    # grab a temporary directory to save all output products there by default 
    outputdir = mktempdir()
else
    # if it doesn't exist, make the directory 
    if !ispath(outputdir)
        mkdir(outputdir)
    end
end

# println("Created $outputdir")

# copy the data file to it 
cp("data.hdf5", joinpath(outputdir, "data.hdf5"))

# change to this directory 
cd(outputdir)

# Create and activate a project environment
using Pkg
Pkg.activate(".")

# Make sure any script started (like those prefixed by `DJ_`) uses this Project.toml first
ENV["JULIA_PROJECT"] = outputdir


# Use the DJ_initialize_environment.jl script (which should be on the PATH)
# to initialize a new environment here.
run(`DJ_initialize_environment.jl`)

# test loading of a dataset 
# test creation of an init structure

# @testset "DiskJockeyTests.jl" begin
#     # First, create the necessary input files
#     run(`DJ_initialize.jl --new-project=standard`)

#     # make plots of the structure
#     run(`DJ_plot_structure.jl`)

#     # run the synthesis
#     run(`DJ_synthesize_model.jl`)

#     # plot the channel maps
#     run(`DJ_plot_chmaps.jl`)

#     # Try downsampling the model to the baseline locations
#     run(`DJ_write_model.jl`)

# end


###################################
### Functional, integration tests
###################################

######################################
### Standard model, fixed distance

# Just make sure the directory is clean
# run(`bash clean.sh`)

# Make a fake model so we can test off of it.
# println("Initializing directory with a new standard project.")

run(`DJ_initialize.jl --new-project=standard`)

# Here test the fix parameters reading routines
include("parameters_fixed.jl")

# Set up the config file and pos0.npy
# println("Editing config.yaml to use the standard model with fixed distance.")
# run(`python edit_config.py --fix-distance --model=standard`)

# Run the initialization and plotting scripts via the make interface
run(`make all`)

# Run venus.jl and see if we sample properly. The idea is to get a simple test with a few walkers without running forever.
# run(`venus.jl --test`)

# Clean up before moving on to the next test
# run(`make clean`)