#!/usr/bin/env bash
#
# Copyright 2025 PKU-Alignment Team. All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ==============================================================================


ACTOR_MODEL_NAME_OR_PATH="meta-llama/Llama-3.1-8B-Instruct" # actor model path
CRITIC_MODEL_NAME_OR_PATH="../outputs/llama_rm" # critic model path
REWARD_MODEL_NAME_OR_PATH="../outputs/llama_rm" # reward model path

TRAIN_DATASETS="PKU-Alignment/PKU-SafeRLHF-single-dimension" # dataset path
TRAIN_TEMPLATE="PKUSafeRLHF" # rlhf dataset template
TRAIN_SPLIT="train" # split the rlhf dataset

PTX_DATASETS="tatsu-lab/alpaca" # sft dataset path
PTX_TEMPLATE="Alpaca" # sft dataset template
PTX_SPLIT="train" # split the sft dataset

export VLLM_DEVICES="0"

DEEPSPEED_DEVICES="localhost:1,2,3,4,5,6,7"

OUTPUT_DIR="../output/llama_ppo_vllm" # output dir
# For wandb online logging
export WANDB_API_KEY=""

# Source the setup script
source ./setup.sh

# Execute deepspeed command
deepspeed \
  --master_port ${MASTER_PORT} \
  --module align_anything.trainers.text_to_text.ppo_vllm \
  --actor_model_name_or_path ${ACTOR_MODEL_NAME_OR_PATH} \
  --reward_model_name_or_path ${REWARD_MODEL_NAME_OR_PATH} \
  --reward_critic_model_name_or_path ${CRITIC_MODEL_NAME_OR_PATH} \
  --train_datasets ${TRAIN_DATASETS} \
  --train_split ${TRAIN_SPLIT} \
  --train_template ${TRAIN_TEMPLATE} \
  --ptx_split ${PTX_SPLIT} \
  --ptx_datasets ${PTX_DATASETS} \
  --ptx_template ${PTX_TEMPLATE} \
  --output_dir ${OUTPUT_DIR}
