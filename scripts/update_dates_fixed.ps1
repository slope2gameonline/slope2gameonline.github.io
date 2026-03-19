# update_dates_fixed.ps1
# Robustly update all project dates to 2026-03-17 in both attributes and visible text.

$baseDate = "2026-03-17"
$root = "d:\game clone\slope\slope_antgravity"

# Function to update a single file
function Update-FilePage {
    param($filePath, $timestamp = $null)
    
    if (!(Test-Path $filePath)) { return }
    $content = Get-Content -Raw $filePath
    
    # 1. Update JSON-LD (Schema)
    if ($timestamp) {
        $fullDt = "$baseDate" + "T$timestamp"
        $content = $content -replace '"datePublished":\s*"[^"]*"', "`"datePublished`": `"$fullDt.000Z`""
        $content = $content -replace '"dateModified":\s*"[^"]*"', "`"dateModified`": `"$fullDt.000Z`""
    } else {
        # Catch-all for schema without specific timestamp (uses 08:00:00 as default for games if not provided)
        $content = $content -replace '"datePublished":\s*"2026-(02|03)-[^"]*"', "`"datePublished`": `"$baseDate`T08:00:00.000Z`""
        $content = $content -replace '"dateModified":\s*"2026-(02|03)-[^"]*"', "`"dateModified`": `"$baseDate`T08:00:00.000Z`""
    }
    
    # 2. Update <time> tags (Attribute AND Inner Text)
    # Using SingleLine mode (?s) to handle multiline tags
    $content = [regex]::replace($content, '(?s)<time\s+itemprop="datePublished"\s+datetime="[^"]*">.*?</time>', "<time itemprop=`"datePublished`" datetime=`"$baseDate`">$baseDate</time>")
    $content = [regex]::replace($content, '(?s)<lastmod>.*?</lastmod>', "<lastmod>$baseDate</lastmod>") # For sitemap if needed, but we handle it separately
    $content = [regex]::replace($content, '(?s)<time\s+itemprop="dateModified"\s+datetime="[^"]*">.*?</time>', "<time itemprop=`"dateModified`" datetime=`"$baseDate`">$baseDate</time>")

    Set-Content -Path $filePath -Value $content -NoNewline
    Write-Host "Processed: $filePath"
}

# 1. Update Homepage
Update-FilePage (Join-Path $root "index.html") "08:00:00"

# 2. Update Game Pages
$gameDirs = Get-ChildItem -Path $root -Directory | Where-Object { 
    $_.Name -notmatch "css|js|assets|scripts|node_modules|brain|tmp|.gemini|.system_generated|.agents" -and 
    $_.Name -notmatch "about-us|contact-us|dmca|privacy-policy|terms-of-service|search|favorites|all.games|arcade.games|adventure.games|sports.games|endless-runner.games|skills.games"
}

$gameTimeStart = [datetime]::ParseExact("08:00:00", "HH:mm:ss", $null)
$counter = 0
foreach ($dir in $gameDirs) {
    $currentTime = $gameTimeStart.AddMinutes($counter).ToString("HH:mm:ss")
    Update-FilePage (Join-Path $dir.FullName "index.html") $currentTime
    $counter++
}

# 3. Update Static/Category Pages
$staticPages = @(
    "all.games", "arcade.games", "adventure.games", "sports.games", "endless-runner.games", "skills.games",
    "about-us", "contact-us", "dmca", "privacy-policy", "terms-of-service", "search", "favorites"
)
foreach ($page in $staticPages) {
    Update-FilePage (Join-Path $root "$page\index.html") "07:00:00"
}

Write-Host "All files updated with date $baseDate"
