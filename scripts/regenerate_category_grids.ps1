
$games = @(
    @{ name = "BLOODMONEY"; categories = "Arcade" },
    @{ name = "Snow Rider 2"; categories = "Adventure, Endless Runner, Skills" },
    @{ name = "Drift Boss"; categories = "Adventure, Arcade, Skills" },
    @{ name = "Subway Surfers"; categories = "Adventure, Endless Runner" },
    @{ name = "Snow Rush 3D"; categories = "Adventure, Endless Runner, Skills" },
    @{ name = "Slope Rider"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slide Down Slope"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slope 3 Online"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slope Multiplayer"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Gate Rusher 2"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Two Ball 3D: Dark"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slope Spooky"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Two Ball 3D"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slope 2"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slope Snowball"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Survive Lava for Brainrots!"; categories = "Arcade, Skills" },
    @{ name = "FastLaners"; categories = "Arcade" },
    @{ name = "Fall Guyz"; categories = "Arcade" },
    @{ name = "Parkour Craft Noob Steve"; categories = "Arcade" },
    @{ name = "Dinosaur City Hunting Destroy"; categories = "Arcade, Skills" },
    @{ name = "Extreme Ball Balancer 3D"; categories = "Arcade, Skills" },
    @{ name = "Finn's Ascent"; categories = "Adventure" },
    @{ name = "Up Together"; categories = "Adventure" },
    @{ name = "Speed Stars"; categories = "Sports" },
    @{ name = "Ski Frenzy"; categories = "Adventure, Endless Runner, Skills" }
)

$trendingNames = @(
    "BLOODMONEY", "Drift Boss", "Subway Surfers", "Snow Rush 3D", "Slope Multiplayer", 
    "Two Ball 3D: Dark", "Speed Stars", "Ski Frenzy", "Slope Snowball", 
    "Dinosaur City Hunting Destroy", "Survive Lava for Brainrots!", 
    "Subway Surfers Winter Holiday", "Finn's Ascent", "Up Together", "Slope Rider"
)

function Get-Slug($name) {
    if ($name -eq "Finn's Ascent") { return "finns-ascent" }
    $s = $name.ToLower().Replace(":", "").Replace("!", "").Replace("'", "").Replace(" ", "-").Replace("--", "-")
    if ($s.EndsWith("-")) { $s = $s.Substring(0, $s.Length - 1) }
    return $s
}

$categories = @("Arcade", "Adventure", "Sports", "Endless Runner", "Skills", "All", "Home")

foreach ($cat in $categories) {
    $filePath = ""
    $filteredGames = @()
    $isHome = $false
    
    if ($cat -eq "Home") {
        $filePath = "index.html"
        $isHome = $true
        foreach ($name in $trendingNames) {
            $g = $games | Where-Object { $_.name -eq $name }
            if ($g) { $filteredGames += $g }
        }
    }
    elseif ($cat -eq "All") {
        $filePath = "all.games/index.html"
        $filteredGames = $games
    }
    else {
        $dir = $cat.ToLower().Replace(" ", "-") + ".games"
        $filePath = "$dir/index.html"
        $filteredGames = $games | Where-Object { $_.categories -like "*$cat*" }
    }

    if (!(Test-Path $filePath)) { 
        if ($cat -eq "Home") {
            # skip
        }
        else {
            Write-Host "Skipping $cat, file not found: $filePath"
            continue 
        }
    }

    # Special case for homepage
    if ($cat -eq "Home" -and !(Test-Path "index.html")) { continue }

    $gridHtml = "<!-- START_GRID -->`n"
    if ($isHome) {
        $gridHtml += "            <div class=`"game-grid reveal`">"
    }
    else {
        $gridHtml += "        <div class=`"game-grid reveal`" style=`"margin-bottom: 4rem;`">"
    }

    foreach ($g in $filteredGames) {
        $slug = Get-Slug $g.name
        $badges = ""
        foreach ($c in $g.categories.Split(",")) {
            $trimmed = $c.Trim()
            $badges += "<div class='game-badge'>$trimmed</div>"
        }
        
        $gridHtml += @"

                <a href='/$slug/' class='game-card'><div class="game-badges">$badges</div>
                    <img src='https://placehold.co/400x300/1f2833/45f248?text=$($g.name.Replace("'", "%27"))' alt='$($g.name)' class='game-thumb' loading='lazy'>
                    <div class='game-info'><h3 class='game-title'>$($g.name)</h3></div>
                </a>
"@
    }
    $gridHtml += "`n            </div>`n            <!-- END_GRID -->"

    $content = Get-Content $filePath -Raw
    $pattern = '(?s)<!-- START_GRID -->.*?<!-- END_GRID -->'
    
    if ($content -match $pattern) {
        $newContent = $content -replace $pattern, $gridHtml
        $newContent | Set-Content $filePath -NoNewline
        Write-Host "Updated $filePath"
    }
    else {
        Write-Host "Warning: Markers not found in $filePath"
    }
}

# Run for Home specifically if not in list
$homePath = "index.html"
if (Test-Path $homePath) {
    $filteredGames = @()
    foreach ($name in $trendingNames) {
        $g = $games | Where-Object { $_.name -eq $name }
        if ($g) { $filteredGames += $g } else {
            # Add a placeholder for games not in master list if wanted
            $filteredGames += @{ name = $name; categories = "Adventure" }
        }
    }
    
    $gridHtml = "<!-- START_GRID -->`n            <div class=`"game-grid reveal`">"
    foreach ($g in $filteredGames) {
        $slug = Get-Slug $g.name
        $badges = ""
        foreach ($c in $g.categories.Split(",")) {
            $trimmed = $c.Trim()
            $badges += "<div class='game-badge'>$trimmed</div>"
        }
        $gridHtml += @"

                <a href='/$slug/' class='game-card'><div class="game-badges">$badges</div>
                    <img src='https://placehold.co/400x300/1f2833/45f248?text=$($g.name.Replace("'", "%27"))' alt='$($g.name)' class='game-thumb' loading='lazy'>
                    <div class='game-info'><h3 class='game-title'>$($g.name)</h3></div>
                </a>
"@
    }
    $gridHtml += "`n            </div>`n            <!-- END_GRID -->"
    
    $content = Get-Content $homePath -Raw
    $pattern = '(?s)<!-- START_GRID -->.*?<!-- END_GRID -->'
    if ($content -match $pattern) {
        $newContent = $content -replace $pattern, $gridHtml
        $newContent | Set-Content $homePath -NoNewline
        Write-Host "Updated homepage trending games"
    }
}
