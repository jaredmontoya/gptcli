import unittest

import gptclipkg/openai
import os

suite "functions tests":
    test "Check if selectEngine function works properly":
        check selectEngine("model") == "https://api.openai.com/v1/engines/model/completions"
    test "Check if openAiToken function works properly":
        putEnv("OPENAI_KEY", "keyvalue")
        check openAiToken("OPENAI_KEY") == "keyvalue"