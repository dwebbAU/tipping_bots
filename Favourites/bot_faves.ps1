$currentRound = Get-Content -Raw -Path E:\Tippy\current_round.json | ConvertFrom-Json
$jsonPayload = @{
    "Round"=$currentRound.Round
}

$tips = @()


ForEach($game in $currentRound.Games){
    $homeOdds = [float]($game.Home.Odds -replace '\$','')
    $awayOdds = [float]($game.Away.Odds -replace '\$','')


    if($homeOdds -gt $awayOdds){
        if($game.MatchId -eq 2){
        $tips += [pscustomobject]@{
            "MatchId" = $game.MatchId
            "TeamId" = $game.Away.TeamId
            "Margin" = 12
            }
        }else{
                $tips += [pscustomobject]@{
            "MatchId" = $game.MatchId
            "TeamId" = $game.Away.TeamId
            "Margin" = $null
            }
            }

    }else{
    if($game.MatchId -eq 2){
$tips += [pscustomobject]@{
            "MatchId" = $game.MatchId
            "TeamId" = $game.Home.TeamId
            "Margin" = 12
            }
        }else{
                $tips += [pscustomobject]@{
            "MatchId" = $game.MatchId
            "TeamId" = $game.Home.TeamId
            "Margin" = $null
            }
            }
    }
}


$jsonPayload.add("Tips",$tips)
$jsonPayload | ConvertTo-Json | out-file e:\tippy\my_tips.json