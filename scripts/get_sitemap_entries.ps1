
$games = @(
    "bloodmoney", "snow-rider-2", "drift-boss", "subway-surfers", "snow-rush-3d", 
    "slope-rider", "slide-down-slope", "slope-3-online", "slope-multiplayer", 
    "gate-rusher-2", "two-ball-3d-dark", "slope-spooky", "slope-2", "slope-snowball", 
    "finns-ascent", "up-together", "santa-run", "ski-frenzy", 
    "subway-surfers-winter-holiday", "g-switch-2", "survive-lava-for-brainrots", 
    "fastlaners", "fall-guyz", "super-traffic-racer", "parkour-craft-noob-steve", 
    "dinosaur-city-hunting-destroy", "extreme-ball-balancer-3d", "speed-stars", 
    "drift-hunters-2", "stunt-bike-extreme"
)

foreach ($slug in $games) {
    Write-Host "  <url>"
    Write-Host "    <loc>https://slope2game.online/$slug/</loc>"
    Write-Host "    <lastmod>2026-02-21</lastmod>"
    Write-Host "    <changefreq>weekly</changefreq>"
    Write-Host "    <priority>0.7</priority>"
    Write-Host "  </url>"
}
