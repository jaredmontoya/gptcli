import os, httpclient, strformat, json
import std/jsonutils

proc openAiToken*(envar: string): string =
    ## Gets OpenAI token from environment variable
    if not existsEnv(envar):
        echo(fmt"Environment variable {envar} is not set, you can get one here: https://beta.openai.com/account/api-keys")
        echo("add this:")
        echo(fmt"  export {envar}=your api key")
        echo("to your .bashrc or .zshrc")
        echo("or if you are on windows, edit environment variables in the settings")
        quit(QuitFailure)
    else:
        return(getEnv(envar))

proc selectEngine*(model: string): string =
    ## Gives an API url for the specified model
    return fmt"https://api.openai.com/v1/engines/{model}/completions"

proc constructClient*(apiKey: string): HttpClient =
    ## constructs a client with custom authentication headers
    var openAiHeaders = newHttpHeaders()
    openAiHeaders.add("Content-Type", "application/json")
    openAiHeaders.add("Authorization", fmt"Bearer {apiKey}")
    openAiHeaders.add("User-Agent", "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Safari/605.1.15',")
    let client = newHttpClient()
    client.headers = openaiheaders
    return(client)

proc constructRequestBody*(input: string, outlength: int,
        temperature: float): string =
    ## Constructs request body for GPTs
    let body = %*{
        "prompt": input,
        "max_tokens": outlength,
        "temperature": temperature
    }
    return($body.toJson())

proc parseOutputBody*(json: string): string =
    ## returns generated text from the returned json
    return(json.parseJson()["choices"][0]["text"].str)
