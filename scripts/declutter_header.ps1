
$files = Get-ChildItem -Path . -Include *.html -Recurse | Where-Object { $_.FullName -notmatch "node_modules" }

foreach ($file in $files) {
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $modified = $false

    # Pattern for the header navigation block
    $navPattern = '(<nav class="nav-links">)([\s\S]*?)(</nav>)'
    
    if ($content -match $navPattern) {
        $navLinks = $matches[2]
        
        # Remove Arcade link
        if ($navLinks -match '<a href="/arcade.games/">Arcade</a>\s*') {
            $navLinks = $navLinks -replace '<a href="/arcade.games/">Arcade</a>\s*', ""
            $modified = $true
        }
        
        # Remove Skills link
        if ($navLinks -match '<a href="/skills.games/">Skills</a>\s*') {
            $navLinks = $navLinks -replace '<a href="/skills.games/">Skills</a>\s*', ""
            $modified = $true
        }

        if ($modified) {
            $newNav = "$($matches[1])$navLinks$($matches[3])"
            $content = $content.Replace($matches[0], $newNav)
            Set-Content -Path $file.FullName -Value $content -Encoding UTF8
            Write-Host "Decluttered header in: $($file.FullName)"
        }
    }
}
