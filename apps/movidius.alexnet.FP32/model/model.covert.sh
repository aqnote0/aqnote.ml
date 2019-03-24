#!/bin/bash

MO_HOME=/opt/intel/computer_vision_sdk_2018.5.455/deployment_tools
INPUT_MODEL_HOME=/home/aqnote/sourceware/org.opencv/open_model_zoo/model_downloader/classification/alexnet/caffe
OUTPUT_MODEL_HOME=.

cd $MO_HOME/model_optimizer

#conda activate intel
python mo.py  \
    --input_model $INPUT_MODEL_HOME/alexnet.caffemodel \
    --input_proto $INPUT_MODEL_HOME/alexnet.prototxt \
    --output_dir $OUTPUT_MODEL_HOME
