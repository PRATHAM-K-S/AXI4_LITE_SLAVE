# ==============================================================================
# VCS Makefile for UVM / SystemVerilog Simulation
# ==============================================================================

# Tool and Simulator options
VCS             := vcs
SIMV            := ./simv

# Design and Testbench Files
TOP_SV          := testbench/axi4_lite_slave_top.sv
INCDIR          := +incdir+./testbench

# Simulation Settings
TESTNAME        := axi4_lite_slave_base_test
VERBOSITY       := UVM_MEDIUM
SEED            := 1

# Compilation Flags
VCS_FLAGS       := -full64 \
                   -sverilog \
                   -ntb_opts uvm \
                   -timescale=1ns/1ps \
                   -debug_access+all \
                   -l compile.log

# Runtime Flags
SIMV_FLAGS      := +UVM_TESTNAME=$(TESTNAME) \
                   +UVM_VERBOSITY=$(VERBOSITY) \
                   +ntb_random_seed=$(SEED) \
                   -l sim.log

# Default Target
.PHONY: all compile run clean help

all: compile run

# ------------------------------------------------------------------------------
# Compile Step
# ------------------------------------------------------------------------------
compile:
	$(VCS) $(VCS_FLAGS) $(INCDIR) $(TOP_SV)

# ------------------------------------------------------------------------------
# Run Batch Simulation
# ------------------------------------------------------------------------------
run:
	$(SIMV) $(SIMV_FLAGS)

# ------------------------------------------------------------------------------
# Cleanup Artifacts
# ------------------------------------------------------------------------------
clean:
	rm -rf simv simv.daidir csrc ucli.key vc_hdrs.h *.log

# ------------------------------------------------------------------------------
# Help
# ------------------------------------------------------------------------------
help:
	@echo "Usage:"
	@echo "  make compile           Compile the design"
	@echo "  make run               Run simulation with default options"
	@echo "  make run TESTNAME=<t>  Run specific UVM test"
	@echo "  make run SEED=random   Run simulation with random seed"
	@echo "  make clean             Remove simulation and build artifacts"