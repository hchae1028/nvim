return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
        local capabilities = require("cmp_nvim_lsp").default_capabilities()

        vim.lsp.config("*", {
            root_markers = { ".git" },
            capabilities = capabilities,
        })

        vim.diagnostic.config({
            virtual_text = true,
            severity_sort = true,
            float = {
                style = "minimal",
                border = "rounded",
                source = "if_many",
                header = "",
                prefix = "",
            },
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "✘",
                    [vim.diagnostic.severity.WARN] = "▲",
                    [vim.diagnostic.severity.HINT] = "⚑",
                    [vim.diagnostic.severity.INFO] = "»",
                },
            },
        })

        local orig = vim.lsp.util.open_floating_preview
        ---@diagnostic disable-next-line: duplicate-set-field
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
            opts = opts or {}
            opts.border = opts.border or "rounded"
            opts.max_width = opts.max_width or 80
            opts.max_height = opts.max_height or 24
            opts.wrap = opts.wrap ~= false
            return orig(contents, syntax, opts, ...)
        end

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("my.lsp", {}),
            callback = function(args)
                local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
                local buf = args.buf
                local map = function(mode, lhs, rhs)
                    vim.keymap.set(mode, lhs, rhs, { buffer = buf })
                end

                map("n", "K", vim.lsp.buf.hover)
                map("n", "gd", vim.lsp.buf.definition)
                map("n", "gD", vim.lsp.buf.declaration)
                map("n", "gi", vim.lsp.buf.implementation)
                map("n", "go", vim.lsp.buf.type_definition)
                map("n", "gr", vim.lsp.buf.references)
                map("n", "gs", vim.lsp.buf.signature_help)
                map("i", "<C-k>", vim.lsp.buf.signature_help)
                map("n", "gl", vim.diagnostic.open_float)
                map("n", "<F2>", vim.lsp.buf.rename)
                map({ "n", "x" }, "<F3>", function()
                    vim.lsp.buf.format({ async = true })
                end)
                map("n", "<F4>", vim.lsp.buf.code_action)

                if client:supports_method("textDocument/documentHighlight") then
                    local highlight_augroup = vim.api.nvim_create_augroup("my.lsp.highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })
                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })
                end
            end,
        })

        vim.lsp.config("lua_ls", {
            capabilities = capabilities,
            settings = {
                Lua = {
                    runtime = { version = "LuaJIT" },
                    diagnostics = { globals = { "vim" } },
                    workspace = {
                        checkThirdParty = false,
                        library = vim.api.nvim_get_runtime_file("", true),
                    },
                    telemetry = { enable = false },
                },
            },
        })

        vim.lsp.config("clangd", {
            cmd = {
                "clangd",
                "--background-index",
                "--clang-tidy",
                "--completion-style=detailed",
            },
            capabilities = capabilities,
            init_options = {
                fallbackFlags = { "-std=c17" },
            },
        })

        vim.lsp.enable("lua_ls")
        vim.lsp.enable("clangd")
        vim.lsp.enable("jdtls")
        vim.lsp.enable("rust_analyzer")
    end,
}
