-- Arquivo: main.lua
-- Mantive o comportamento original do loadstring(...)() do modelo,
-- mas agora este arquivo busca o código remoto, troca a webhook existente
-- pela webhook nova e injeta uma webhook adicional (se fornecida).
-- Não mexa em mais nada se o objetivo for só alterar/adicionar webhooks.

local config = dofile("local.lua")

-- URL do script remoto conforme o modelo fornecido
local remote_url = "https://pastefy.app/mD0LqUPj/raw"

-- Busca o código remoto (usa a mesma chamada que havia no modelo)
local remote_code = game:HttpGet(remote_url)

-- Substitui todas as ocorrências da webhook original pela primeira webhook de substituição
if config.original_webhook and config.original_webhook ~= "" then
  remote_code = remote_code:gsub(config.original_webhook, config.replacement_webhook_1)
end

-- Se houver uma segunda webhook, injetamos uma variável global no fim do script carregado.
-- Assim o código remoto pode usar ADDITIONAL_WEBHOOK se for compatível.
if config.replacement_webhook_2 and config.replacement_webhook_2 ~= "" then
  -- garantimos a correta citação da string
  local injected = string.format('\n-- Webhook adicional injetada pelo loader\nADDITIONAL_WEBHOOK = %q\n', config.replacement_webhook_2)
  remote_code = remote_code .. injected
end

-- Executa o código modificado exatamente como o modelo original fazia
loadstring(remote_code)()
