import strutils, json
import cligen, pyopenai
import gptclipkg/funcs


# Painless keyboard interruption
proc ctrlc() {.noconv.} =
  quit(QuitSuccess)
setControlCHook(ctrlc)


proc gptcli(chat = false, instant = false, debug = false,
    model = "gpt-3.5-turbo", length: uint = 0, temperature = 1.0,
    systemPrompt = "You are a helpful assistant.",
    apiKey = "OPENAI_API_KEY", apiBase = "https://api.openai.com/v1",
    prompt: seq[string]
  ): int =
  var openai = OpenAiClient(
    apiKey: getOpenaiToken(apiKey),
    apiBase: apiBase
  )
  var messages: seq[JsonNode]

  if systemPrompt != "":
    messages.add(
      %*{
        "role": "system",
        "content": systemPrompt
      }
    )

  case chat:
    of true:
      echo("Type quit to stop")

      while true:
        let data = input("\nYou: ")

        if data != "quit":
          messages.add(
            %*{
              "role": "user",
              "content": data
            }
          )

          let resp = openai.createChatCompletion(
            model = model,
            messages = messages,
            maxTokens = length,
            temperature = temperature
          )

          messages.add(
            resp["choices"][0]["message"]
          )

          let output = resp["choices"][0]["message"]["content"].str

          if debug == true:
            echo(resp.pretty())

          stdout.write("\nAI: ")
          if instant == true:
            echo(output)
          else:
            printSlow(output, 10)
        else:
          quit(QuitSuccess)
    else:
      messages.add(
        %*{
          "role": "user",
          "content": prompt.join(" ")
        }
      )

      let resp = openai.createChatCompletion(
        model = model,
        messages = messages,
        maxTokens = length,
        temperature = temperature
      )

      messages.add(
        resp["choices"][0]["message"]
      )

      let output = strip(resp["choices"][0]["message"]["content"].str)

      if debug == true:
        echo(resp.pretty())

      if instant == true:
        echo(output)
      else:
        printSlow(output, 10)

when isMainModule:
  dispatch(gptcli, help = {
    "chat": "open in chat mode",
    "instant": "instantly prints all of the response",
    "debug": "prints returned json for debugging",
    "model": "select a different model",
    "length": "choose the max length of the response in tokens",
    "temperature": "the level of randomness in model's response",
    "system-prompt": "choose a system ptompt used for the model",
    "api-key": "choose an environment variable to read the api key from",
    "api-base": "choose a base api url"
  })
