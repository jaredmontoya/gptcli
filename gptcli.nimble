# Package

version       = "3.0.0"
author        = "HACKKER"
description   = "OpenAI GPTs cli client written in nim"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["gptcli"]


# Dependencies

requires "nim >= 1.6.0"
requires "cligen >= 1.5.32"
