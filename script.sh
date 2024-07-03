#!/bin/bash

# Color variables
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "\n${BLUE}Installing aligned_layer and setting up environment...${NC}\n"
curl -L https://raw.githubusercontent.com/yetanotherco/aligned_layer/main/batcher/aligned/install_aligned.sh | bash
source /home/gitpod/.bashrc  # Ensure .bashrc is sourced to update PATH

echo -e "\n${BLUE}Getting proof test files...${NC}\n"
curl -L https://raw.githubusercontent.com/yetanotherco/aligned_layer/main/batcher/aligned/get_proof_test_files.sh | bash

echo -e "\n${BLUE}Removing existing verification data (if any)...${NC}\n"
rm -rf ~/.aligned/aligned_verification_data/

export PATH="$PATH:/home/gitpod/.aligned/bin"

echo -e "\n${BLUE}Submitting proof to aligned_layer...${NC}\n"
aligned submit \
--proving_system SP1 \
--proof ~/.aligned/test_files/sp1_fibonacci.proof \
--vm_program ~/.aligned/test_files/sp1_fibonacci.elf \
--aligned_verification_data_path ~/.aligned/aligned_verification_data \
--conn wss://batcher.alignedlayer.com

sleep 60

echo -e "\n${BLUE}Verifying proof onchain...${NC}\n"
aligned verify-proof-onchain \
--aligned-verification-data ~/.aligned/aligned_verification_data/*.json \
--rpc https://ethereum-holesky-rpc.publicnode.com \
--chain holesky

echo -e "\n${GREEN}Script execution completed.${NC}\n"
