import httpclient, json, strformat, os, strutils
import std/jsonutils

#painless stopping
proc ctrlc() {.noconv.} =
  quit(QuitSuccess)
setControlCHook(ctrlc)

#check if api key environment variable is set
if not existsEnv("OPENAI_API_KEY"):
  echo("Environment variable OPENAI_API_KEY is not set, you can get one here: https://beta.openai.com/account/api-keys")
  echo("add this:")
  echo("  export OPENAI_API_KEY=your api key")
  echo("to your .bashrc or .zshrc")
  quit(QuitFailure)

#request settings
let apiKey = getEnv("OPENAI_API_KEY")
let model = "text-davinci-002"
let maxLength = 2048

proc printSlow(s: string) =
  for ch in s:
    stdout.write(ch)
    stdout.flushFile()
    if ch != ' ':
      sleep(10)
  stdout.write('\n')
  stdout.write('\n')

# Set the URL for the request
let url = fmt"https://api.openai.com/v1/engines/{model}/completions"

#define headers
var openaiheaders = newHttpHeaders()
openaiheaders.add("Content-Type", "application/json")
openaiheaders.add("Authorization", fmt"Bearer {apiKey}")
openaiheaders.add("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Safari/605.1.15',")

# Create a new HTTP client
let client = newHttpClient()

# Set the headers for the request
client.headers = openaiheaders

# Set the body of the request
let inputprompt = commandLineParams().join(" ")

let body = %*{
  "prompt": inputprompt,
  "max_tokens": maxLength,
  "temperature": 0.5
}

# Send the post request and handle the response
let resp = client.post(url, body = $body.toJson())

if resp.status != $Http200:
  echo("Error: ", resp.status)
else:
  let result = resp.body.parseJson()
  let output = result["choices"][0]["text"].str
  printSlow(output)