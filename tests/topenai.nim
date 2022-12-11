import unittest

import gptclipkg/openai
import os

suite "function tests":
    test "Check if selectEngine function works properly":
        check selectEngine() == "https://api.openai.com/v1/engines/text-davinci-002/completions"
        check selectEngine("model") == "https://api.openai.com/v1/engines/model/completions"
    test "Check if openAiToken function works properly":
        putEnv("OPENAI_API_KEY", "keyvalue")
        check openAiToken() == "keyvalue"
        putEnv("OPENAI_KEY", "keyvalue1")
        check openAiToken("OPENAI_KEY") == "keyvalue1"