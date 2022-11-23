This is just a helper command to build React component files.

Currently it assume that you have `"src/types"` as alias to your types folder, and assume that you have MUI (https://mui.com/) and will use it as a framework, in the future it should be possible to support javascript (non-typescript) and perhaps use a template? so that'd be easier to use and customize between projects, but right now I don't need it yet, and current code works fine

### Install

Just include `create-component.sh` file into your `.bashrc` or `.zshrc`, example for zsh:
`source ~/Documents/my-bashes/create-component.sh`

### Usage

`ccomp NameOfYourComponent --options`

#### Options

| name | description                                              |
| ---- | -------------------------------------------------------- |
| `-a` | Create component inside `src/component/atoms` folder     |
| `-m` | Create component inside `src/component/molecules` folder |
| `-o` | Create component inside `src/component/organisms` folder |

> By default it will create component on the current working directory
