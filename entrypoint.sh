#!/bin/bash
#
# SNPE container entrypoint
#

export LD_LIBRARY_PATH=${CAFFE_LIBRARY_PATH}:/opt/conda/envs/snpe/lib:/usr/local/lib${LD_LIBRARY_PATH+:${LD_LIBRARY_PATH}}
export PATH=/snpe/bin/x86_64-linux-clang:${PATH}
# export TF_CPP_MIN_LOG_LEVEL=2

source /root/.profile
conda activate snpe

if [ ! -f "${SNPE_ROOT}/bin/envsetup.sh" ]; then
    echo -e "\033[1;31mERROR: \033[0mSNPE directory \033[0;35m${SNPE_ROOT} \033[0mdoesn't contains \033[0;34mbin/envsetup.sh\033[0m!"
    echo -e "\033[0mYou must specify your SNPE binaries directory (top folder including models/ LICENSE.pdf, etc)"
    echo -e "\033[0mas docker mountpoint at \033[0;35m${SNPE_ROOT}\033[0m (e.g. \033[0;37mdocker run ... -v <local_path_to_snpe>:${SNPE_ROOT} ... jungin500/snpe\033[0m)"
    exit 1;
fi

# . ${SNPE_ROOT}/bin/envsetup.sh -c ${CAFFE_ROOT}
# update PYTHONPATH
export PYTHONPATH=${CAFFE_ROOT}:$PYTHONPATH

# . ${SNPE_ROOT}/bin/envsetup.sh -t ${TENSORFLOW_ROOT}
export TENSORFLOW_HOME=${TENSORFLOW_ROOT}

# Start bash with user-provided command arguments
sed -i "s/conda activate base/conda activate snpe/g" ~/.bashrc
/bin/bash -- $@
# /bin/bash --rcfile <(set | egrep -v 'UID|GID|BASHOPTS|BASH_VERSINFO|EUID|PPID|SHELLOPTS|IFS') -- $@