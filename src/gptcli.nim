import os, strutils, strformat, json
import cligen, pyopenai

# Painless keyboard interruption
proc ctrlc() {.noconv.} =
    quit(QuitSuccess)
setControlCHook(ctrlc)

proc getOpenaiToken(envar: string): string =
    ## Gets OpenAI token from environment variable
    if not existsEnv(envar):
        echo(fmt"Environment variable {envar} is not set, you can get one here: https://beta.openai.com/account/api-keys")
        echo("add this:")
        echo(fmt"  export {envar}=your api key")
        echo("to your .bashrc or .zshrc")
        echo("or if you are on windows, edit environment variables in the settings")
        quit(QuitFailure)
    else:
        return getEnv(envar)

# Prints characters one by one
proc printSlow(s: string, delay: int) =
    for ch in s:
        stdout.write(ch)
        stdout.flushFile()
        if ch != ' ':
            sleep(delay)
    stdout.write('\n')

proc input(prompt = ""): string =
    if prompt.len > 0:
        stdout.write(prompt)
    stdin.readLine()

proc gptcli(chat = false, instant = false, verbose = false,
        model = "text-davinci-003", length: uint = 2048, temperature = 0.5,
                apikeyvar = "OPENAI_API_KEY",
        userinput: seq[string]): int =
    var openai = OpenAiClient(apiKey: getOpenaiToken(apikeyvar))
    case chat:
        of true:
            echo("Type quit to stop")
            while true:
                let data = input("\nYou: ")
                if data != "quit":
                    let resp = openai.createCompletion(
                        model = model,
                        prompt = data,
                        maxTokens = length,
                        temperature = temperature
                    )

                    if verbose == true:
                        echo(resp.pretty())

                    let output = resp["choices"][0]["text"].str
                    stdout.write("\nAI: ")
                    if instant == true:
                        echo(output)
                    else:
                        printSlow(output, 10)
                else:
                    quit(QuitSuccess)
        else:
            let resp = openai.createCompletion(
                        model = model,
                        prompt = userinput.join(" "),
                        maxTokens = length,
                        temperature = temperature
                    )

            if verbose == true:
                echo(resp.pretty())

            let output = strip(resp["choices"][0]["text"].str)

            if instant == true:
                echo(output)
            else:
                printSlow(output, 10)

dispatch(gptcli, help = {
    "chat": "open in chat mode",
    "instant": "instantly prints all of the response",
    "verbose": "prints entire json for debugging",
    "model": "select a different model",
    "length": "choose the max length of the response",
    "temperature": "the level of randomness in models' response",
    "apikeyvar": "choose an environment variable from which the api key is taken"
})
