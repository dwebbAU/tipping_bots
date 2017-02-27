$currentRound = Get-Content -Raw -Path E:\Tippy\current_round.json | ConvertFrom-Json
$jsonPayload = @{
    "Round"=$currentRound.Round
}

$tips = @()


ForEach($game in $currentRound.Games){
    $dayOfMonth = ([DateTime]$game.KickOff).Day

    $dayOfMonth
    if(($game.Home.TeamId - $dayOfMonth) -lt ($game.Away.TeamId)){
        $teamId = $game.Home.TeamId
    }else{
        $teamId = $game.Away.TeamId
    }

    if($game.IsMarginGame){
        $margin = [math]::Abs($game.Home.TeamId - $dayOfMonth)
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
$jsonPayload | ConvertTo-Json | out-file e:\tippy\my_tips_dom.json