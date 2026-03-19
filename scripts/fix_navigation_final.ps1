
$files = Get-ChildItem -Path . -Include *.html -Recurse | Where-Object { $_.FullName -notmatch "node_modules" }

$correctHeaderNav = @"
            <nav class="nav-links">
                <a href="/all.games/">All Games</a>
                <a href="/adventure.games/">Adventure</a>
                <a href="/sports.games/">Sports</a>
                <a href="/endless-runner.games/">Endless Runner</a>
            </nav>
"@

$correctFooterNav = @"
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
    $content = Get-Content -Path $file.FullName -Raw -Encoding UTF8
    
    # Fix Header Nav
    $headerPattern = '(?i)<nav class="nav-links">[\s\S]*?</nav>'
    if ($content -match $headerPattern) {
        $content = [regex]::Replace($content, $headerPattern, $correctHeaderNav)
    }

    # Fix Footer Nav (Category block)
    $footerPattern = '(?i)<h3>Categories</h3>\s*<div class="footer-links">[\s\S]*?</div>'
    $newFooterBlock = "<h3>Categories</h3>`n" + $correctFooterNav
    if ($content -match $footerPattern) {
        $content = [regex]::Replace($content, $footerPattern, $newFooterBlock)
    }

    Set-Content -Path $file.FullName -Value $content -Encoding UTF8
    Write-Host "Fixed navigation in: $($file.FullName)"
}
