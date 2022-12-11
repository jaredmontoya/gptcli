import httpclient, os, strutils
import gptclipkg/openai

# Painless keyboard interruption
proc ctrlc() {.noconv.} =
  quit(QuitSuccess)
setControlCHook(ctrlc)

# Prints characters one by one
proc printSlow(s: string, delay: int) =
  for ch in s:
    stdout.write(ch)
    stdout.flushFile()
    if ch != ' ':
      sleep(delay)
  stdout.write('\n')
  stdout.write('\n')

proc input(prompt = ""): string =
    ## Python-like ``input()`` procedure.
    if prompt.len > 0:
      stdout.write(prompt)
    stdin.readLine()

let helptxt = """Usage: gptcli give me a hello world program written in nim...
Parameters are combined into a unified string and are used as a prompt

Arguments:
  --help    displays this message
  --start   very convinient if you want to ask multiple questions

https://nimble.directory/pkg/gptcli"""

# Set the body of the request
if paramStr(1) == "--help":
  echo(helptxt)
elif paramStr(1) == "--start":
  let client = constructClient(openAiToken())
  echo("Type quit to stop\n")
  while true:
    let data = input("~$: ")
    if data != "quit":
      let resp = client.post(selectEngine(), body = constructRequestBody(data, 2048, 0.5))

      if resp.status != $Http200:
        echo("Error: ", resp.status)
      else:
        let result = parseOutputBody(resp.body)
        echo("\nChatGPT~>")
        printSlow(result, 10)
    else:
      quit(QuitSuccess)
else:
  let client = constructClient(openAiToken())

  let inputText = commandLineParams().join(" ")

  let resp = client.post(selectEngine(), body = constructRequestBody(inputText, 2048, 0.5))

  if resp.status != $Http200:
    echo("Error: ", resp.status)
  else:
    let result = parseOutputBody(resp.body)
    printSlow(result, 10)