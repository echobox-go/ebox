<p align="center">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://raw.githubusercontent.com/echobox-go/.github/main/profile/assets/mark-dark.svg">
    <img src="https://raw.githubusercontent.com/echobox-go/.github/main/profile/assets/mark-light.svg" alt="echobox-go" width="96">
  </picture>
</p>

<h1 align="center">ebox</h1>

<p align="center"><b>The echobox-go CLI.</b> Saves your Linux environment to your own server and brings it back on any computer.</p>

---

```
sudo ebox enrol          # once per machine or stick: pair with the portal
sudo ebox push           # save packages + /etc, dotfiles, desktop settings, home files
sudo ebox pull           # restore them (runs automatically at boot on a stick)
ebox build               # ask the portal for a fresh ISO
ebox status
```

| What | Tool | Stored in |
|---|---|---|
| Packages and `/etc` changes | aconfmgr | your state repo (`aconfmgr/`) |
| Dotfiles | chezmoi | your dotfiles repo |
| Plasma / GNOME settings | konsave / dconf | your state repo (`desktop/`) |
| Home folders (`sync.home_paths`) | restic | rest-server on `eb-state`, append-only |
| Credentials from enrolment | — | `/var/lib/ebox` on the stick's LUKS partition |

Install on an existing Arch or CachyOS machine with the one-liner the portal
serves (`enrol.sh`), or build the package: `make package` (runs `makepkg` in `packaging/`).

## Not done yet

- Portal side of `enrol` and `build` (the portal answers 501).
- Pangolin client start (`EBOX_TUNNEL_UP_CMD` is a placeholder).
- Creating the persistence partition (`persist-open` only unlocks an existing one).
- `push --image` (penguins-eggs).
- `aconfmgr apply` is interactive, so `pull --boot` skips packages unless
  `EBOX_ACONFMGR_FLAGS` is set.

## Development

```sh
make test        # bash -n, a status smoke test, shellcheck
make package     # build the pacman package
```

The builder repo copies `bin/ebox` and `systemd/` into every live ISO, so
clone this repo next to it (`~/echobox-go/ebox`).

Part of [echobox-go](https://github.com/echobox-go): `ebox` · [`builder`](https://github.com/echobox-go/builder) · [`portal`](https://github.com/echobox-go/portal)

<sub>echobox-go is an independent project and is not affiliated with Arch Linux or CachyOS.</sub>
