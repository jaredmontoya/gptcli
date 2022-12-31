import os, httpclient, strformat, json
import std/jsonutils

const apiUrl* = "https://api.openai.com/v1/completions"

proc openaiToken*(envar: string): string =
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

proc constructClient*(apiKey: string, userAgent="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.1 Safari/605.1.15',"): HttpClient =
    ## constructs a client with custom authentication headers
    var openAiHeaders = newHttpHeaders()
    openAiHeaders.add("Content-Type", "application/json")
    openAiHeaders.add("Authorization", fmt"Bearer {apiKey}")
    openAiHeaders.add("User-Agent", userAgent)
    let client = newHttpClient()
    client.headers = openaiheaders
    return(client)

proc constructRequestBody*(engine: string, input: string, maxTokens: int,
        temperature: float): string =
    ## Constructs request body for GPTs
    let body = %*{
        "model": engine,
        "prompt": input,
        "max_tokens": maxTokens,
        "temperature": temperature
    }
    return($body.toJson())

proc parseText*(json: string): string =
    ## returns text value from OpenAI's json
    return(json.parseJson()["choices"][0]["text"].str)

proc parseFinishReason*(json: string): string =
    ## returns finish_reason value from OpenAI's json
    return(json.parseJson()["choices"][0]["finish_reason"].str)

proc parseId*(json: string): string =
    ## returns id value from OpenAI's json
    return(json.parseJson()["id"].str)