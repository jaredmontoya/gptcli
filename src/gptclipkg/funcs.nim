import os, strformat


proc getOpenaiToken*(envar: string): string =
  ## Gets OpenAI token from environment variable
  if not existsEnv(envar):
    echo(fmt"Environment variable {envar} is not set, you can get one here: https://platform.openai.com/account/api-keys")
    echo("add this:")
    echo(fmt"  export {envar}=your api key")
    echo("to your .bashrc or .zshrc")
    echo("or if you are on windows, edit environment variables in the settings")
    quit(QuitFailure)
  else:
    return getEnv(envar)


# Prints characters one by one
proc printSlow*(s: string, delay: int) =
  for ch in s:
    stdout.write(ch)
    stdout.flushFile()
    if ch != ' ':
      sleep(delay)
  stdout.write('\n')


proc input*(prompt = ""): string =
  if prompt.len > 0:
    stdout.write(prompt)
  stdin.readLine()
