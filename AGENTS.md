# Notes For Codex In This Repo

## Repo Layout
- This top-level `dotfiles` repo contains a Git submodule at `nvim/.config/nvim-lazy`.
- Treat `nvim/.config/nvim-lazy` as its own Git repository with its own history, branches, and dirty state.

## Branching Expectations
- In the top-level `dotfiles` repo, history is typically linear on `master`.
- Do not assume feature branches are used in the top-level repo unless the user asks for one.
- In the `nvim/.config/nvim-lazy` submodule, branch-based work is normal.
- The submodule currently uses a custom branch named `chrostow/custom` on top of upstream `main`.

## Working With The Submodule
- When `git status` in the top-level repo shows `nvim/.config/nvim-lazy` as modified, first check whether the submodule itself is dirty rather than assuming the submodule pointer changed.
- Inspect submodule state with commands scoped to the nested repo, for example `git -C nvim/.config/nvim-lazy status` and `git -C nvim/.config/nvim-lazy log`.
- Be explicit about which repo a Git recommendation applies to: top-level `dotfiles` or nested `nvim-lazy`.
- If changes are intended to stay local to the submodule, it is acceptable for the top-level repo to show the submodule as dirty.
- If the user wants a clean top-level repo, resolve submodule dirtiness by either committing or discarding changes inside `nvim/.config/nvim-lazy`, then updating the top-level submodule pointer only if needed.
