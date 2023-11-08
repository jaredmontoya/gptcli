# Package

version       = "4.0.0"
author        = "jaredmontoya"
description   = "OpenAI GPTs cli client written in nim"
license       = "GPL-3.0-or-later"
srcDir        = "src"
installExt    = @["nim"]
bin           = @["gptcli"]


# Dependencies

requires "nim ^= 2.0.0"
requires "cligen ^= 1.6.16"
requires "pyopenai ^= 0.2.0"
