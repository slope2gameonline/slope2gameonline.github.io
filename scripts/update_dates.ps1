# update_dates.ps1
# Synchronize all project dates to 2026-03-17 with sequential timestamps.

$baseDate = "2026-03-17"
$gameTimeStart = [datetime]::ParseExact("08:00:00", "HH:mm:ss", $null)
$staticTime = "07:00:00"

# List of game directories (excluding special folders)
$root = "d:\game clone\slope\slope_antgravity"
$gameDirs = Get-ChildItem -Path $root -Directory | Where-Object { 
    $_.Name -notmatch "css|js|assets|scripts|node_modules|brain|tmp|.gemini|.system_generated|.agents" -and 
    $_.Name -notmatch "about-us|contact-us|dmca|privacy-policy|terms-of-service|search|favorites|all.games|arcade.games|adventure.games|sports.games|endless-runner.games|skills.games"
}

$gamePaths = $gameDirs.FullName

# 1. Update Homepage
$homeIndex = Join-Path $root "index.html"
if (Test-Path $homeIndex) {
    $content = Get-Content -Raw $homeIndex
    $timeStr = "08:00:00"
    $fullDt = "$baseDate" + "T$timeStr"
    
    # Update JSON-LD
    $content = $content -replace '"datePublished":\s*"[^"]*"', "`"datePublished`": `"$fullDt.000Z`""
    $content = $content -replace '"dateModified":\s*"[^"]*"', "`"dateModified`": `"$fullDt.000Z`""
    
    # Update HTML <time>
    $content = $content -replace '<time itemprop="datePublished" datetime="[^"]*">', "<time itemprop=`"datePublished`" datetime=`"$baseDate`">"
    $content = $content -replace '<time itemprop="dateModified" datetime="[^"]*">', "<time itemprop=`"dateModified`" datetime=`"$baseDate`">"
    $content = $content -replace 'Latest update: <time itemprop="dateModified" datetime="[^"]*">[^<]*</time>', "Latest update: <time itemprop=`"dateModified`" datetime=`"$baseDate`">$baseDate</time>"
    $content = $content -replace 'Publish Date: <time itemprop="datePublished" datetime="[^"]*">[^<]*</time>', "Publish Date: <time itemprop=`"datePublished`" datetime=`"$baseDate`">$baseDate</time>"
    
    Set-Content -Path $homeIndex -Value $content -NoNewline
    Write-Host "Updated index.html"
}

# 2. Update Game Pages sequentially
$counter = 0
foreach ($dir in $gamePaths) {
    $indexPath = Join-Path $dir "index.html"
    if (Test-Path $indexPath) {
        $currentTime = $gameTimeStart.AddMinutes($counter).ToString("HH:mm:ss")
        $fullDt = "$baseDate" + "T$currentTime"
        
        $content = Get-Content -Raw $indexPath
        
        # Update JSON-LD
        $content = $content -replace '"datePublished":\s*"[^"]*"', "`"datePublished`": `"$fullDt.000Z`""
        $content = $content -replace '"dateModified":\s*"[^"]*"', "`"dateModified`": `"$fullDt.000Z`""
        
        # Update HTML <time>
        $content = $content -replace '<time itemprop="datePublished" datetime="[^"]*">', "<time itemprop=`"datePublished`" datetime=`"$baseDate`">"
        $content = $content -replace '<time itemprop="dateModified" datetime="[^"]*">', "<time itemprop=`"dateModified`" datetime=`"$baseDate`">"
        $content = $content -replace 'Latest update: <time itemprop="dateModified" datetime="[^"]*">[^<]*</time>', "Latest update: <time itemprop=`"dateModified`" datetime=`"$baseDate`">$baseDate</time>"
        $content = $content -replace 'Publish Date: <time itemprop="datePublished" datetime="[^"]*">[^<]*</time>', "Publish Date: <time itemprop=`"datePublished`" datetime=`"$baseDate`">$baseDate</time>"
        
        Set-Content -Path $indexPath -Value $content -NoNewline
        Write-Host "Updated $indexPath with $currentTime"
        $counter++
    }
}

# 3. Update Static/Category Pages
$staticPages = @(
    "all.games", "arcade.games", "adventure.games", "sports.games", "endless-runner.games", "skills.games",
    "about-us", "contact-us", "dmca", "privacy-policy", "terms-of-service", "search", "favorites"
)

foreach ($page in $staticPages) {
    $indexPath = Join-Path $root "$page\index.html"
    if (Test-Path $indexPath) {
        $fullDt = "$baseDate" + "T$staticTime"
        $content = Get-Content -Raw $indexPath
        
        $content = $content -replace '"datePublished":\s*"[^"]*"', "`"datePublished`": `"$fullDt.000Z`""
        $content = $content -replace '"dateModified":\s*"[^"]*"', "`"dateModified`": `"$fullDt.000Z`""
        
        Set-Content -Path $indexPath -Value $content -NoNewline
        Write-Host "Updated static page $indexPath"
    }
}

# 4. Update Sitemap
$sitemapPath = Join-Path $root "sitemap.xml"
if (Test-Path $sitemapPath) {
    $content = Get-Content -Raw $sitemapPath
    
    # Update homepage in sitemap
    $homeLastMod = "$baseDate" + "T08:00:00Z"
    $content = $content -replace '<loc>https://slope2game.online/</loc><lastmod>[^<]*</lastmod>', "<loc>https://slope2game.online/</loc><lastmod>$homeLastMod</lastmod>"
    
    # Reset counter for sitemap
    $counter = 0
    foreach ($dirName in ($gameDirs.Name)) {
        $currentTime = $gameTimeStart.AddMinutes($counter).ToString("HH:mm:ss")
        $sitemapDt = "$baseDate" + "T$currentTime" + "Z"
        
        # Regex to match the loc and update its following lastmod
        $regex = "(<loc>https://slope2game.online/$dirName</loc><lastmod>)[^<]*(</lastmod>)"
        $content = [regex]::replace($content, $regex, "${1}$sitemapDt${2}")
        
        $counter++
    }
    
    # Update static pages in sitemap
    foreach ($page in $staticPages) {
        $sitemapDt = "$baseDate" + "T$staticTime" + "Z"
        $regex = "(<loc>https://slope2game.online/$page/</loc><lastmod>)[^<]*(</lastmod>)"
        $content = [regex]::replace($content, $regex, "${1}$sitemapDt${2}")
    }
    
    # Fallback for simple date-only lastmod entries
    $content = $content -replace '<lastmod>2026-02-[^<]*</lastmod>', "<lastmod>$baseDate</lastmod>"
    
    Set-Content -Path $sitemapPath -Value $content -NoNewline
    Write-Host "Updated sitemap.xml"
}
