# LMCACHE_USE_EXPERIMENTAL=True \
# LMCACHE_CHUNK_SIZE=256 \
# LMCACHE_LOCAL_CPU=False \
# LMCACHE_REMOTE_URL=lm://localhost:65433 \
# LMCACHE_REMOTE_SERDE=cachegen \
# VLLM_ATTENTION_BACKEND=FLASH_ATTN \
# vllm serve mistralai/Mistral-7B-Instruct-v0.2 --kv-transfer-config \
#     '{"kv_connector":"LMCacheConnector","kv_role":"kv_both"}' \
#     --port 8000 \
#     --enforce-eager \
#     --enable-chunked-prefill false --disable-log-requests


vllm serve mistralai/Mistral-7B-Instruct-v0.2 \
    --port 8000 \
    --enforce-eager \
    --enable-chunked-prefill false --disable-log-requests