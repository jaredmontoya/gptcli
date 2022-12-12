# Package

version       = "1.2.0"
author        = "HACKKER"
description   = "chatgpt cli client written in nim"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["gptcli"]


# Dependencies

requires "nim >= 1.2.0"
requires "cligen >= 1.5.32"