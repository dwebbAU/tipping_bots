# Run .\bot_dayofmonth.ps1 -username <username> -password <password>

Param(
    [Parameter(Mandatory=$true)]
    [string]$username,
    [Parameter(Mandatory=$true)]
    [string]$password
    )


$roundEndpoint = "http://bcs-tip.azurewebsites.net/api/round/current?u=$($username)&p=$($password)"
$tipEndpoint = "http://bcs-tip.azurewebsites.net/api/tips/submit?u=$($username)&p=$($password)"

$currentRound = Invoke-WebRequest -Uri $roundEndpoint | ConvertFrom-Json

$jsonPayload = @{
    "Round"=$currentRound.Round
}

$tips = @()


ForEach($game in $currentRound.Games){
    $dayOfMonth = ([DateTime]$game.KickOff).Day

    # Calc smallest difference between day of month and teamid and tip accordingly
    if(($game.Home.TeamId - $dayOfMonth) -lt ($game.Away.TeamId - $dayOfMonth)){
        $teamId = $game.Home.TeamId

    }else{
        $teamId = $game.Away.TeamId
 
    }

    # Set margin if margin game
    if($game.IsMarginGame){
        $margin = [math]::Abs($teamId - $dayOfMonth)
    }else{
        $margin = $null
    }

    $tips += [pscustomobject]@{
        "MatchId" = $game.MatchId
        "TeamId" = $teamId
        "Margin" = $margin
    }
    
}


$jsonPayload.add("Tips",$tips)
$response = Invoke-WebRequest -Uri $tipEndpoint -ContentType 'application/json' -Method POST -Body ($jsonPayload | ConvertTo-Json)

if ($response.StatusCode -eq 200){
    Write-Host -ForegroundColor Green "Tips have been submitted successfully"
}else{
    Write-Host -ForegroundColor Red "Tips failed"
    $response.StatusCode
}