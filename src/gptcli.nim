import httpclient, os, strutils, cligen
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
    if prompt.len > 0:
      stdout.write(prompt)
    stdin.readLine()

proc gptcli(start=false, model="text-davinci-003", length=2048, temperature=0.5, apikeyvar="OPENAI_API_KEY", userinput: seq[string]): int =
  if start == true:
    let client = constructClient(openAiToken(apikeyvar))
    echo("Type quit to stop\n")
    while true:
      let data = input("~$: ")
      if data != "quit":
        let resp = client.post(selectEngine(model), body = constructRequestBody(data, 2048, 0.5))

        if resp.status != $Http200:
          echo("Error: ", resp.status)
        else:
          let output = parseOutputBody(resp.body)
          echo("\nAI~>")
          printSlow(output, 10)
      else:
        quit(QuitSuccess)
  else:
    let client = constructClient(openAiToken(apikeyvar))

    let resp = client.post(selectEngine(model), body = constructRequestBody(userinput.join(" "), length, temperature))

    if resp.status != $Http200:
      echo("Error: ", resp.status)
    else:
      let output = parseOutputBody(resp.body)
      printSlow(output, 10)

dispatch(gptcli, help = {
  "start": "open chat",
  "model": "select a different model",
  "length": "choose the max length of the output text",
  "temperature": "the level of randomness in models' response",
  "apikeyvar": "change the environment variable where the api key is taken from"
})