# Package

version       = "3.2.1"
author        = "jaredmontoya"
description   = "OpenAI GPTs cli client written in nim"
license       = "MIT"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["gptcli"]


# Dependencies

requires "nim >= 1.6.0"
requires "cligen >= 1.5.32"
requires "pyopenai >= 0.1.0"
