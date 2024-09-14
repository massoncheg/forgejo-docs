---
title: 'Development environment'
license: 'Apache-2.0'
origin_url: 'https://github.com/go-gitea/gitea/blob/ec1feedbf582b05b6a5e8c59fb2457f25d053ba2/docs/content/development/hacking-on-gitea.en-us.md'
---

This page lists a few options to set up a productive development environment for working on Forgejo.

## VSCodium

[VSCodium](https://vscodium.com/) is an open source version of the Visual Studio Code IDE.
The [Go integration for Visual Studio Code](https://code.visualstudio.com/docs/languages/go) works
with VSCodium and is a viable tool to work on Forgejo.

First, run `cp -r contrib/ide/vscode .vscode` to create new directory `.vscode` with the contents of folder [contrib/ide/vscode](https://codeberg.org/forgejo/forgejo/src/branch/forgejo/contrib/ide/vscode) at the root of the repository. Then, open the project directory in VSCodium.

You can now use `Ctrl`+`Shift`+`B` to build the gitea executable and `F5` to run it in debug mode.

Tests can be run by clicking on the `run test` or `debug test` button above their declaration.

Go code is formatted automatically when saved.

## Emacs

[GNU Emacs](https://www.gnu.org/software/emacs/) is an open source implementation of the Emacs text editor.
The [Emacs Go-mode](https://github.com/dominikh/go-mode.el), in combination with the [Go language-server](https://github.com/golang/tools/blob/master/gopls/doc/emacs.md) and a LSP client can be used to work on Forgejo's code base.

A prejequisite for working with the language server is [installing gopls](https://github.com/golang/tools/blob/master/gopls/README.md#installation).
After this, you'll want to install the necessary packages in Emacs using `M-x package-install` followed by `go-mode` and your preferred LSP client, so _either_ `lsp-mode` _or_ `eglot`.

After the installation, you'll need to activate the packages in your [initialization file](https://www.gnu.org/software/emacs/manual/html_node/emacs/Init-File.html).
Regardless of your choice of LSP client, you'll need to add:

```elisp
(require 'go-mode)
(require 'go-mode-load)
```

If you would like a full list of the features of go-mode, have a look at [this blogpost by it's creator](https://honnef.co/articles/writing-go-in-emacs/).

Then, for lsp-mode, add:

```elisp
(use-package lsp-mode
  :ensure
  :commands lsp
  :custom
  (add-hook 'lsp-mode-hook 'lsp-ui-mode) ;; Optional, see below
  (add-hook 'go-mode-hook #'lsp-deferred))

;; lsp-ui mode is optional. It shows inline hints.
(use-package lsp-ui
  :ensure
  :commands lsp-ui-mode
  :custom
  (lsp-ui-peek-always-show t)
  (lsp-ui-sideline-show-hover t)
  (lsp-ui-doc-enable nil))

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)
```

Or for eglot:

```elisp
(require 'project)

(defun project-find-go-module (dir)
  (when-let ((root (locate-dominating-file dir "go.mod")))
    (cons 'go-module root)))

(cl-defmethod project-root ((project (head go-module)))
  (cdr project))

(add-hook 'project-find-functions #'project-find-go-module)

(require 'eglot)
(add-hook 'go-mode-hook 'eglot-ensure)

;; Optional: install eglot-format-buffer as a save hook.
;; The depth of -10 places this before eglot's willSave notification,
;; so that that notification reports the actual contents that will be saved.
(defun eglot-format-buffer-before-save ()
  (add-hook 'before-save-hook #'eglot-format-buffer -10 t))
(add-hook 'go-mode-hook #'eglot-format-buffer-before-save)
```

As additional quality of life inprovements, you might consider installing [company](https://company-mode.github.io/), [flycheck](https://www.flycheck.org/en/latest/) and/or [magit](https://magit.vc/). Consider the package website for a complete explanation and installation instructions.

<details>
<summary> Here is an init example if you just want to use all three packages </summary>

```elisp
;; company
(use-package company
  :ensure
  :custom
  (company-idle-delay 0) ;; how long to wait until popup
  (company-minimum-prefix-length 1)
  ;; (company-begin-commands nil) ;; uncomment to disable popup
  :bind
  (:map company-active-map
	("C-n". company-select-next)
	("C-p". company-select-previous)
	("M-<". company-select-first)
	("M->". company-select-last)
	)
  ;; Tab-override
  (:map company-mode-map
	("<tab>". tab-indent-or-complete)
	("TAB". tab-indent-or-complete)
	)
  )

(add-hook 'after-init-hook 'global-company-mode)


;; flycheck
(use-package flycheck :ensure)


;; magit
(use-package magit :ensure)
```

</details>

## Vim

Vim has [a Go plugin](https://github.com/fatih/vim-go) that can likely be used to work on Forgejo's code base.
Do you know how to configure it properly? Why not document that here?

## Neovim

Here's a minimal example that configures `gopls` and `golangci_lint_ls` using
the `Lazy.nvim` plugin manager.

<details>
<summary>init.lua</summary>

```lua
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	"neovim/nvim-lspconfig",
	{
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "make",
				cond = vim.fn.executable("make") == 1,
			},
		},
	},
})

vim.g.mapleader = " "
vim.g.maplocalleader = " "

local on_attach = function(client, bufno)
	-- depricated since neovim 0.10
	-- vim.api.nvim_buf_set_option(bufno, "omnifunc", "v:lua.vim.lsp.omnifunc")
	vim.api.nvim_set_option_value("omnifunc", "v:lua.vim.lsp.omnifunc", { buf = bufno })

	local ts = require("telescope.builtin")
	local opts = { buffer = bufno }

	vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
	vim.keymap.set("n", "gtd", vim.lsp.buf.type_definition, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	vim.keymap.set("n", "gu", ts.lsp_references, opts)
	vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
	vim.keymap.set("n", "<leader>cl", vim.lsp.codelens.run, opts)
	vim.keymap.set("n", "<leader>r", vim.lsp.buf.rename, opts)
	vim.keymap.set("n", "<leader>f", function()
		vim.lsp.buf.format({ async = true })
	end, opts)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()

require("lspconfig")["gopls"].setup({
	capabilities = capabilities,
	settings = {},
	on_attach = on_attach,
})

require("lspconfig")["golangci_lint_ls"].setup({
	capabilities = capabilities,
	settings = {},
	on_attach = on_attach,
})
```

</details>
