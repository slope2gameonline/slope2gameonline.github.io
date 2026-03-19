
$files = Get-ChildItem -Path . -Include *.html -Recurse | Where-Object { $_.FullName -notmatch "node_modules" }

$correctTagPills = @"
        <div class="tag-pills container reveal">
            <a href="/arcade.games/" class="tag-pill">Arcade</a>
            <a href="/adventure.games/" class="tag-pill">Adventure</a>
            <a href="/sports.games/" class="tag-pill">Sports</a>
            <a href="/endless-runner.games/" class="tag-pill">Endless Runner</a>
            <a href="/skills.games/" class="tag-pill">Skills</a>
        </div>
"@

$correctFooterLinks = @"
                <div class="footer-links">
                    <a href="/arcade.games/">Arcade</a>
                    <a href="/adventure.games/">Adventure</a>
                    <a href="/sports.games/">Sports</a>
                    <a href="/endless-runner.games/">Endless Runner</a>
                    <a href="/skills.games/">Skills</a>
                    <a href="/all.games/">All Games</a>
                </div>
"@

foreach ($file in $files) {
    if ($file.FullName -match "scripts") { continue }
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    $modified = $false

    # Fix Tag Pills
    $pillsPattern = '(?i)<div class="tag-pills[^">]*">[\s\S]*?</div>'
    if ($content -match $pillsPattern) {
        $content = [regex]::Replace($content, $pillsPattern, $correctTagPills)
        $modified = $true
    }

    # Fix Footer Category Links (Standardize again and fix potential omissions)
    $footerPattern = '(?i)<h3>Categories</h3>\s*<div class="footer-links">[\s\S]*?</div>'
    $newFooterBlock = "<h3>Categories</h3>`n" + $correctFooterLinks
    if ($content -match $footerPattern) {
        $content = [regex]::Replace($content, $footerPattern, $newFooterBlock)
        $modified = $true
    }

    if ($modified) {
        Set-Content -Path $file.FullName -Value $content -Encoding UTF8
        Write-Host "Fixed categories and pills in: $($file.FullName)"
    }
}
