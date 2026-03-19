
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
    @{ name = "Slope 2"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slope Snowball"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Finn's Ascent"; categories = "Adventure" },
    @{ name = "Up Together"; categories = "Adventure" },
    @{ name = "Santa Run"; categories = "Adventure, Endless Runner, Skills" },
    @{ name = "Ski Frenzy"; categories = "Adventure, Endless Runner, Skills" },
    @{ name = "Subway Surfers Winter Holiday"; categories = "Adventure, Endless Runner, Skills" },
    @{ name = "G-Switch 2"; categories = "Adventure, Endless Runner, Skills" },
    @{ name = "Survive Lava for Brainrots!"; categories = "Arcade, Skills" },
    @{ name = "FastLaners"; categories = "Arcade" },
    @{ name = "Fall Guyz"; categories = "Arcade" },
    @{ name = "Super Traffic Racer"; categories = "Sports, Adventure" },
    @{ name = "Parkour Craft Noob Steve"; categories = "Arcade" },
    @{ name = "Dinosaur City Hunting Destroy"; categories = "Arcade, Skills" },
    @{ name = "Extreme Ball Balancer 3D"; categories = "Arcade, Skills" },
    @{ name = "Speed Stars"; categories = "Sports" },
    @{ name = "Drift Hunters 2"; categories = "Sports" },
    @{ name = "Stunt Bike Extreme"; categories = "Sports" }
)

$files = Get-ChildItem -Path . -Include *.html -Recurse | Where-Object { 
    $_.FullName -notmatch "node_modules" -and 
    $_.FullName -notmatch "scripts" -and
    $_.FullName -notmatch "\\(bloodmoney|snow-rider-2|drift-boss|subway-surfers|snow-rush-3d|slope-rider|slide-down-slope|slope-3-online|slope-multiplayer|gate-rusher-2|two-ball-3d-dark|slope-spooky|slope-2|slope-snowball|finns-ascent|up-together|santa-run|ski-frenzy|subway-surfers-winter-holiday|g-switch-2|survive-lava-for-brainrots|fastlaners|fall-guyz|super-traffic-racer|parkour-craft-noob-steve|dinosaur-city-hunting-destroy|extreme-ball-balancer-3d|speed-stars|drift-hunters-2|stunt-bike-extreme)\\"
}

foreach ($file in $files) {
    if ($file.FullName -match "\\(arcade.games|adventure.games|sports.games|endless-runner.games|skills.games|all.games)\\index.html" -or $file.Name -eq "index.html" -or $file.Name -eq "search.html" -or $file.Name -eq "favorites.html") {
        # This targets the list pages specifically
    }
    else {
        continue
    }

    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $modified = $false

    foreach ($game in $games) {
        $name = $game.name
        $categories = $game.categories.Split(",")
        
        $badgesHtml = '<div class="game-badges">'
        foreach ($cat in $categories) {
            $trimmedCat = $cat.Trim()
            $badgesHtml += "<div class='game-badge'>$trimmedCat</div>"
        }
        $badgesHtml += '</div>'

        # Regex to find the game card for this game and replace its badge
        # We look for a game-card that contains the title
        $pattern = '(?s)(<a\s+href="[^"]+"[^>]*class="game-card"[^>]*>)\s*<div\s+class="game-badge">[^<]+</div>(.*?<h3\s+class="game-title">[^<]*' + [regex]::Escape($name) + '[^<]*</h3>.*?</a>)'
        
        if ($content -match $pattern) {
            $content = $content -replace $pattern, "`$1$badgesHtml`$2"
            $modified = $true
        }
    }

    if ($modified) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Updated cards in: $($file.FullName)"
    }
}
