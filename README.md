# End-to-end test for LMCache

> Note: currently, this doc is for onboarding the new developers. Will have a separate README in the future for general audiences.

It's recommended to create a new folder before cloning the repository. The final file structure will look like as follows:

```
<parent-folder>/
|--- lmcache-test/
|--- LMCache/
|--- lmcache-vllm/
```

## 1. Environment installation


```bash
# Create conda environment
conda create -n lmcache python=3.10
conda activate lmcache

# Clone github repository
git clone git@github.com:LMCache/lmcache-tests.git
cd lmcache-tests
pip install vllm==0.7.0
git clone https://github.com/LMCache/LMCache.git
cd LMCache 
pip install -e .
cd ..
git clone https://github.com/LMCache/lmcache-vllm.git
cd lmcache-vllm 
pip install -e . 
# Now copy LMCache/docker/patch/factory.py and LMCache/docker/patch/lmcache_connector.py to <PATH TO VLLM>/vllm/distributed/kv_transfer/kv_connector/
# For example, for me
cd ..
cp LMCache/docker/patch/factory.py ~/.local/miniconda3/envs/lmcache/lib/python3.10/site-packages/vllm/distributed/kv_transfer/kv_connector/
cp LMCache/docker/patch/lmcache_connector.py ~/.local/miniconda3/envs/lmcache/lib/python3.10/site-packages/vllm/distributed/kv_transfer/kv_connector/

```

## 2. Run the tests

### 2.1 Quickstart example

First start LMCache server:

```
python3 -m lmcache.experimental.server localhost 65433 cpu 
```

and start vllm server:
```
LMCACHE_USE_EXPERIMENTAL=True \
LMCACHE_CHUNK_SIZE=256 \
LMCACHE_LOCAL_CPU=False \
LMCACHE_REMOTE_URL=lm://localhost:65433 \
LMCACHE_REMOTE_SERDE=cachegen \
VLLM_ATTENTION_BACKEND=FLASH_ATTN \
vllm serve mistralai/Mistral-7B-Instruct-v0.2 --kv-transfer-config \
    '{"kv_connector":"LMCacheConnector","kv_role":"kv_both"}' \
    --port 8000 \
    --enforce-eager \
    --enable-chunked-prefill false --disable-log-requests
```


And then run the following code by:

```
VLLM_ATTENTION_BACKEND=FLASH_ATTN python3 main.py tests/tests.py -f test_local_cpu_experimental -o outputs/
```