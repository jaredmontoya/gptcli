import unittest

import gptclipkg/openai
import os

suite("Function Tests"):
    test("Check if openAiToken function works like intended"):
        putEnv("OPENAI_KEY", "keyvalue")
        check openAiToken("OPENAI_KEY") == "keyvalue"
    test("Check if constructRequestBody function works like intended"):
        check constructRequestBody("testmodel", "test", 2048, 0.5) == "{\"model\":\"testmodel\",\"prompt\":\"test\",\"max_tokens\":2048,\"temperature\":0.5}"
    test("Check if parseText function works like intended"):
        check parseText("{\"id\":\"cmpl-FZT28hhgHUtNEF1IejibHhpCpODXx\",\"object\":\"text_completion\",\"created\":1586839808,\"model\":\"text-davinci-003\",\"choices\":[{\"text\":\"\n\ntest\",\"index\":0,\"logprobs\":null,\"finish_reason\":\"stop\"}],\"usage\":{\"prompt_tokens\":4,\"completion_tokens\":10,\"total_tokens\":14}}") == "\n\ntest"
    test("Check if parseFinishReason function works like intended"):
        check parseFinishReason("{\"id\":\"cmpl-FZT28hhgHUtNEF1IejibHhpCpODXx\",\"object\":\"text_completion\",\"created\":1586839808,\"model\":\"text-davinci-003\",\"choices\":[{\"text\":\"\n\ntest\",\"index\":0,\"logprobs\":null,\"finish_reason\":\"stop\"}],\"usage\":{\"prompt_tokens\":4,\"completion_tokens\":10,\"total_tokens\":14}}") == "stop"
    test("Check if parseId function works like intended"):
        check parseId("{\"id\":\"cmpl-FZT28hhgHUtNEF1IejibHhpCpODXx\",\"object\":\"text_completion\",\"created\":1586839808,\"model\":\"text-davinci-003\",\"choices\":[{\"text\":\"\n\ntest\",\"index\":0,\"logprobs\":null,\"finish_reason\":\"stop\"}],\"usage\":{\"prompt_tokens\":4,\"completion_tokens\":10,\"total_tokens\":14}}") == "cmpl-FZT28hhgHUtNEF1IejibHhpCpODXx"