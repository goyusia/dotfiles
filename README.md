# dotfiles

https://www.chezmoi.io/

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply git@github.com:goyusia/dotfiles.git

chezmoi apply
chezmoi git
```

## windows
neovim 기본 설정 파일 위치 `C:\Users\5MINLAB\AppData\Local\nvim`
리눅스와 설정파일 위치를 공유하려면 설정파일 위치를 바꿔야한다.
환경변수로 `XDG_CONFIG_HOME` 추가하면 된다. `%USERPROFILE%\.config`

