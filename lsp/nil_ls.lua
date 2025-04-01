return {
    -- root_dir = find_root_pattern({ "flake.nix", ".git" }),
    root_markers = { "flake.nix", ".git" },
    cmd = { "nil" },
    filetypes = { "nix" },
    single_file_support = true,
}
