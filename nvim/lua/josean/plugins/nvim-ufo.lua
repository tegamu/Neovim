-- ~/.config/nvim/lua/plugins/nvim-ufo.lua
return {
  "kevinhwang91/nvim-ufo",
  event = "VeryLazy",
  dependencies = {
    "kevinhwang91/promise-async",
    -- 선택: 있으면 자동으로 LSP 폴딩을 활용
    { "neovim/nvim-lspconfig", optional = true },
  },
  init = function()
    vim.o.foldcolumn = "0"       -- 필요 시 "1"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true
  end,
  config = function()
    local ok_ufo, ufo = pcall(require, "ufo")
    if not ok_ufo then return end

    ----------------------------------------------------------------
    -- Neovim 0.11: vim.lsp.config 사용 환경에 맞춘 foldingRange 주입
    ----------------------------------------------------------------
    local function with_folding(cap)
      cap = cap or vim.lsp.protocol.make_client_capabilities()
      cap.textDocument = cap.textDocument or {}
      cap.textDocument.foldingRange = { dynamicRegistration = false, lineFoldingOnly = true }
      return cap
    end

    -- 이미 등록된 모든 서버 설정(vim.lsp.config[server])에 folding capability 병합
    if type(vim.lsp.config) == "table" then
      for name, cfg in pairs(vim.lsp.config) do
        if type(cfg) == "table" then
          local merged = vim.tbl_deep_extend("force", {}, cfg)
          merged.capabilities = with_folding(merged.capabilities)

          -- (선택) nvim-cmp/blink를 쓰면 여기서도 병합 시도
          pcall(function()
            merged.capabilities = require("cmp_nvim_lsp").default_capabilities(merged.capabilities)
          end)
          pcall(function()
            merged.capabilities = require("blink.cmp").get_lsp_capabilities(merged.capabilities)
          end)

          vim.lsp.config[name] = merged
        end
      end
    end

    ----------------------------------------------------------------
    -- ufo 설정
    ----------------------------------------------------------------
    ufo.setup({
      provider_selector = function(_, _, _)
        -- LSP 폴딩 우선, 보조로 indent
        return { "lsp", "indent" }
      end,
      open_fold_hl_timeout = 0,
      preview = { win_config = { border = "rounded", winblend = 0 } },
    })

    -- 키맵
    vim.keymap.set("n", "zR", ufo.openAllFolds, { desc = "UFO: open all folds" })
    vim.keymap.set("n", "zM", ufo.closeAllFolds, { desc = "UFO: close all folds" })
    vim.keymap.set("n", "zr", ufo.openFoldsExceptKinds, { desc = "UFO: open except kinds" })
    vim.keymap.set("n", "zm", ufo.closeFoldsWith, { desc = "UFO: close with level" })
    vim.keymap.set("n", "K", function()
      local winid = require("ufo").peekFoldedLinesUnderCursor()
      if not winid then vim.lsp.buf.hover() end
    end)
  
  end,
}

