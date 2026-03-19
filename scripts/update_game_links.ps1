
$games = @(
    @{ name = "BLOODMONEY"; slug = "bloodmoney" },
    @{ name = "Snow Rider 2"; slug = "snow-rider-2" },
    @{ name = "Drift Boss"; slug = "drift-boss" },
    @{ name = "Subway Surfers"; slug = "subway-surfers" },
    @{ name = "Snow Rush 3D"; slug = "snow-rush-3d" },
    @{ name = "Slope Rider"; slug = "slope-rider" },
    @{ name = "Slide Down Slope"; slug = "slide-down-slope" },
    @{ name = "Slope 3 Online"; slug = "slope-3-online" },
    @{ name = "Slope Multiplayer"; slug = "slope-multiplayer" },
    @{ name = "Gate Rusher 2"; slug = "gate-rusher-2" },
    @{ name = "Two Ball 3D: Dark"; slug = "two-ball-3d-dark" },
    @{ name = "Slope Spooky"; slug = "slope-spooky" },
    @{ name = "Slope 2"; slug = "slope-2" },
    @{ name = "Slope Snowball"; slug = "slope-snowball" },
    @{ name = "Finn's Ascent"; slug = "finns-ascent" },
    @{ name = "Up Together"; slug = "up-together" },
    @{ name = "Santa Run"; slug = "santa-run" },
    @{ name = "Ski Frenzy"; slug = "ski-frenzy" },
    @{ name = "Subway Surfers Winter Holiday"; slug = "subway-surfers-winter-holiday" },
    @{ name = "G-Switch 2"; slug = "g-switch-2" },
    @{ name = "Survive Lava for Brainrots!"; slug = "survive-lava-for-brainrots" },
    @{ name = "FastLaners"; slug = "fastlaners" },
    @{ name = "Fall Guyz"; slug = "fall-guyz" },
    @{ name = "Super Traffic Racer"; slug = "super-traffic-racer" },
    @{ name = "Parkour Craft Noob Steve"; slug = "parkour-craft-noob-steve" },
    @{ name = "Dinosaur City Hunting Destroy"; slug = "dinosaur-city-hunting-destroy" },
    @{ name = "Extreme Ball Balancer 3D"; slug = "extreme-ball-balancer-3d" },
    @{ name = "Speed Stars"; slug = "speed-stars" },
    @{ name = "Drift Hunters 2"; slug = "drift-hunters-2" },
    @{ name = "Stunt Bike Extreme"; slug = "stunt-bike-extreme" }
)

$files = Get-ChildItem -Path . -Include *.html -Recurse | Where-Object { $_.FullName -notmatch "node_modules" }

foreach ($file in $files) {
    if ($file.Name -eq "index.html" -and $file.DirectoryName -match "slug\.games") {
        # Category page processing
    }

    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $modified = $false

    foreach ($game in $games) {
        $name = $game.name
        $slug = "/$($game.slug)/"
        
        # Regex to find the <a> tag for this game
        # We look for the game title in alt or h3 within a game-card
        $pattern = "(<a\s+href=)`"#`"(\s+class=`"game-card`"[^>]*>[\s\S]*?(?:alt|game-title)[^>]*?>$([regex]::Escape($name))[\s\S]*?</a>)"
        
        if ($content -match $pattern) {
            $content = $content -replace $pattern, "`$1`"$slug`"`$2"
            $modified = $true
        }
    }

    if ($modified) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Updated links in: $($file.FullName)"
    }
}
