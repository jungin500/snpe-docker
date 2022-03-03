Unofficial Dockerized Qualcomm Neural Processing SDK (SNPE - Snapdragon Neural Processing Engine)  

[![SNPE Version](https://img.shields.io/badge/snpe-1.53.2-blue)](https://developer.qualcomm.com/software/qualcomm-neural-processing-sdk/tools) [![jungin500/snpe-docker](https://img.shields.io/badge/github-jungin500%2Fsnpe--docker-brightgreen)](https://github.com/jungin500/snpe-docker) [![jungin500/snpe](https://img.shields.io/badge/docker-jungin500%2Fsnpe-blue)](https://hub.docker.com/r/jungin500/snpe)

# Description
- I've packaged Qualcomm's SNPE SDK into dockerized environment, as installing Caffe over different environment took ALMOST FULL DAY for me! (BVLC/caffe didn't supplied python wheel file, and caffe V1 repository was deprecated as there was no updates in recent 2 years!)

# License
- Qualcomm's PKLA(Product Kit License Aggrement) indicates that SDK should not be included in open source in any forms (refer to the license text:
    ```
    3.5. Open Source Prohibition.
    LICENSEE shall not ... incorporate, link, distribute or use any third party software or code in conjunction with any part of a PKLA Product Kit ...
    ```
- If you agree the [Full License](https://developer.qualcomm.com/license/snapdragon-developer-tools-license), you could [download](https://developer.qualcomm.com/software/qualcomm-neural-processing-sdk/tools) SNPE SDK. Recommending to use it for educational/study purpose.

# Requirements
- Windows(Docker Desktop with WSL2), Linux
- Docker
- Qualcomm Neural Processing SDK for AI v1.53.2 (or newer): [Download snpe-1.53.2.zip](https://developer.qualcomm.com/software/qualcomm-neural-processing-sdk)
    - WARNING: Version under (or same as) `SNPE 1.48.0` would not work. Qualcomm changed host platform from Ubuntu 16.04 to 18.04, and a lot of libraries are changed. Try at your own adventure.
- Boost 1.77.0 source: [Download boost_1_77_0.tar.gz](https://boostorg.jfrog.io/artifactory/main/release/1.77.0/source)  
  (Be aware that boost's distribution platform `jfrog` didn't let me automatically download their sourcecode using wget!)

# Usage
1. Download `snpe-1.53.2.zip` or newer.
2. Create new empty directory and unzip file `snpe-1.53.2.zip` into that directory.
3. Run following command (`${SNPE_ROOT}` refers to current directory, you could replace it with `$(pwd)` on linux, or full path on windows WSL2 environment)
    ```shell
    docker run \
        -it --rm \
        -v ${SNPE_ROOT}:/snpe \
        jungin500/snpe:1.5x
    ```

4. (Optional) Run examples inside SNPE SDK's `/snpe/models` directory:
    ```shell
    cd /snpe

    # It will take some time (5~10mins) to download AlexNet from Caffe repository
    python models/alexnet/scripts/setup_alexnet.py -a models/alexnet/assets -d
    ```

    Output should show up like following:
    ```
    ... (Download sequence)

    Copying Caffe model
    Modiying prototxt to use a batch size of 1
    Creating DLC
    2021-09-09 08:45:54,886 - 188 - INFO - across channels=True
    2021-09-09 08:45:54,887 - 188 - INFO - across channels=True
    2021-09-09 08:45:55,901 - 188 - INFO - INFO_DLC_SAVE_LOCATION: Saving model at /snpe/models/alexnet/dlc/bvlc_alexnet.dlc
    2021-09-09 08:46:18,776 - 188 - INFO - INFO_CONVERSION_SUCCESS: Conversion completed successfully
    Getting imagenet aux data
    Creating ilsvrc_2012_mean.npy
    Creating %s ilsvrc_2012_mean_cropped.bin
    Creating ilsvrc_2012_labels.txt
    Create SNPE alexnet input
    processing /snpe/models/alexnet/data/chairs.jpg
    processing /snpe/models/alexnet/data/notice_sign.jpg
    processing /snpe/models/alexnet/data/plastic_cup.jpg
    processing /snpe/models/alexnet/data/trash_bin.jpg
    Create file lists
    /snpe/models/alexnet/data/cropped/raw_list.txt created listing 4 files.
    /snpe/models/alexnet/data/target_raw_list.txt created listing 4 files.
    Setup alexnet completed.
    ```

    and result model `.dlc` file would be created on `models/alexnet/dlc/bvlc_alexnet.dlc`:
    ```
    (snpe) root@fc6441ac1308:/snpe# ls -alh models/alexnet/dlc/
    total 233M
    drwxrwxrwx 1 1000 1000 4.0K Sep  9 07:18 .
    drwxrwxrwx 1 1000 1000 4.0K Sep  8 08:40 ..
    -rwxrwxrwx 1 1000 1000 233M Sep  9 08:46 bvlc_alexnet.dlc
    ```

5. You can use SNPE's python tools listed below:
    ```
    snpe-caffe-to-dlc
    snpe-caffe2-to-dlc
    snpe-diagview
    snpe-dlc-diff
    snpe-dlc-info
    snpe-dlc-quantize
    snpe-dlc-reorder
    snpe-dlc-viewer
    snpe-net-run
    snpe-onnx-to-dlc
    snpe-parallel-run
    snpe-platform-validator-py
    snpe-tensorflow-to-dlc
    snpe-tflite-to-dlc
    snpe-throughput-net-run
    snpe-udo-package-generator
    ```

