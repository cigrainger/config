require("lint").linters_by_ft = {
	dockerfile = { "hadolint", "trivy" },
	elixir = { "credo" },
	fish = { "fish" },
	markdown = { "vale" },
	nix = { "nix", "deadnix", "statix" },
	terraform = { "tflint", "trivy" },
	toml = { "taplo" },
	typescript = { "eslint_d", "stylelint", "prettier" },
	yaml = { "yamllint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		-- try_lint without arguments runs the linters defined in `linters_by_ft`
		-- for the current filetype
		require("lint").try_lint()
	end,
})
