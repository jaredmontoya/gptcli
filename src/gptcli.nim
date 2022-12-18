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

proc gptcli(start = false, instant = false, verbose = false,
        model = "text-davinci-003", length = 2048, temperature = 0.5,
                apikeyvar = "OPENAI_API_KEY",
        userinput: seq[string]): int =
    if start == true:
        let client = constructClient(openAiToken(apikeyvar))
        echo("Type quit to stop\n")
        while true:
            let data = input("You: ")
            if data != "quit":
                let resp = client.post(apiUrl,
                        body = constructRequestBody(model, data, 2048, 0.5))

                if resp.status != $Http200:
                    echo("Error: ", resp.status)
                else:
                    if verbose == true:
                        echo("\n", resp.body)

                    let output = strip(parseText(resp.body))
                    stdout.write("\nAI: ")
                    if instant == true:
                        echo(output)
                    else:
                        printSlow(output, 10)
            else:
                quit(QuitSuccess)
    else:
        let client = constructClient(openAiToken(apikeyvar))

        let resp = client.post(apiUrl, body = constructRequestBody(model,
                userinput.join(" "), length, temperature))

        if resp.status == $Http200:
            if verbose == true:
                echo("\n", resp.body)

            let output = strip(parseText(resp.body))

            if instant == true:
                echo(output)
            else:
                printSlow(output, 10)
        elif resp.status == $Http401:
            echo("The API key that you provided is invalid")
        elif resp.status == $Http404:
            echo("The model that you selected does not exist")
        elif resp.status == $Http400:
            echo("Some of the parameters that you provided are invalid")
        else:
            echo("Error: ", resp.status)

dispatch(gptcli, help = {
    "start": "open chat",
    "instant": "instantly prints all of the response",
    "verbose": "prints entire json for debugging",
    "model": "select a different model",
    "length": "choose the max length of the response",
    "temperature": "the level of randomness in models' response",
    "apikeyvar": "change the environment variable where the api key is taken from"
})
