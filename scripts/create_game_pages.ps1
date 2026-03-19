
$games = @(
    @{ name = "BLOODMONEY"; embed = "https://bloodmoneygame.io/game/bloodmoney/"; categories = "Arcade" },
    @{ name = "Snow Rider 2"; embed = "https://st.8games.net/14/igra-snezhnyj-gonshchik-3d/"; categories = "Adventure, Endless Runner, Skills" },
    @{ name = "Drift Boss"; embed = "https://driftbossonline.github.io/file/"; categories = "Adventure, Arcade, Skills" },
    @{ name = "Subway Surfers"; embed = "https://memelite70.github.io/assets/subway-surfers/"; categories = "Adventure, Endless Runner" },
    @{ name = "Snow Rush 3D"; embed = "https://st.8games.net/7/8g/igra-snezhnyj-ryvok-3d/"; categories = "Adventure, Endless Runner, Skills" },
    @{ name = "Slope Rider"; embed = "https://game.azgame.io/slope-rider/"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slide Down Slope"; embed = "https://gamea.azgame.io/slide-down/"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slope 3 Online"; embed = "https://kdata1.com/2024/03/slope-kbh/"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slope Multiplayer"; embed = "https://storage.y8.com/y8-studio/html5/akeemywka/slope_multiplayer_v6/"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Gate Rusher 2"; embed = "https://html5.gamemonetize.co/6svrnf8a20mkj7aaxznr803fpc96jabl/"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Two Ball 3D: Dark"; embed = "https://files.twoplayergames.org/files/games/o1/Two_Ball_3D_Dark/index.html"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slope Spooky"; embed = "https://www.miniplay.com/embed/slope-spooky"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slope 2"; embed = "https://g1.igru.net/6/igra-slop-2/"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Slope Snowball"; embed = "https://st.8games.net/10/8g/igra-snezhok-na-sklone/"; categories = "Arcade, Endless Runner, Skills" },
    @{ name = "Finn's Ascent"; embed = "https://www.finnsascent.com/"; categories = "Adventure" },
    @{ name = "Up Together"; embed = "https://uptogether.io/"; categories = "Adventure" },
    @{ name = "Santa Run"; embed = "https://1games.io/game/santa-run/"; categories = "Adventure, Endless Runner, Skills" },
    @{ name = "Ski Frenzy"; embed = "https://1games.io/game/ski-frenzy/"; categories = "Adventure, Endless Runner, Skills" },
    @{ name = "Subway Surfers Winter Holiday"; embed = "https://ubg77.github.io/updatefaqs/subway-surfers-winter-holiday/"; categories = "Adventure, Endless Runner, Skills" },
    @{ name = "G-Switch 2"; embed = "https://www.twoplayergames.org/gameframe/g-switch-2"; categories = "Adventure, Endless Runner, Skills" },
    @{ name = "Survive Lava for Brainrots!"; embed = "https://html5.gamemonetize.co/uyn7pwgdh4ijluks2v0flc800pindkoh/"; categories = "Arcade, Skills" },
    @{ name = "FastLaners"; embed = "https://html5.gamemonetize.co/fiaa5lho6mt9zuyzakdhzo84t1yy2nuh/"; categories = "Arcade" },
    @{ name = "Fall Guyz"; embed = "https://html5.gamemonetize.co/epnb67gydx5b7fujbf6glepkav88egqs/"; categories = "Arcade" },
    @{ name = "Super Traffic Racer"; embed = "https://html5.gamemonetize.co/a5w7favv4e53hhyfev78m7xs0dcefnew/"; categories = "Sports, Adventure" },
    @{ name = "Parkour Craft Noob Steve"; embed = "https://html5.gamemonetize.co/8mkc1eq0noitttklorxjpoe5epn9mafv/"; categories = "Arcade" },
    @{ name = "Dinosaur City Hunting Destroy"; embed = "https://html5.gamemonetize.co/s5pt5t35wuln49vilycw1j81w5ypdm50/"; categories = "Arcade, Skills" },
    @{ name = "Extreme Ball Balancer 3D"; embed = "https://html5.gamemonetize.co/8b9vp8opunp1ainfejmtmlpaha2yuzy7/"; categories = "Arcade, Skills" },
    @{ name = "Speed Stars"; embed = "https://kdata1.com/5000/2025/speedstars11/"; categories = "Sports" },
    @{ name = "Drift Hunters 2"; embed = "https://kdata1.com/2017/09/drift-hunters-2/"; categories = "Sports" },
    @{ name = "Stunt Bike Extreme"; embed = "https://kdata1.com/5000/2025/stunt-bike-extreme1/"; categories = "Sports" }
)

function Get-Slug($name) {
    return $name.ToLower().Replace(":", "").Replace("!", "").Replace("'", "").Replace(" ", "-").Replace("--", "-")
}

$template = @"
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>{{TITLE}} - Slope 2</title>
    <meta name="description" content="Play {{TITLE}} on Slope 2. Experience high-speed action, stunning graphics, and addictive gameplay. Play now for free!">
    <link rel="icon" type="image/png" href="/favicon.png">
    <link rel="canonical" href="https://slope2game.online/{{SLUG}}/">
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;700&family=Outfit:wght@500;700;800&display=swap" rel="stylesheet">
    <meta property="og:type" content="website">
    <meta property="og:url" content="https://slope2game.online/{{SLUG}}/">
    <meta property="og:title" content="{{TITLE}} - Slope 2 Game">
    <meta property="og:description" content="Play {{TITLE}} on Slope 2. High-speed action and neon graphics. Play now for free!">
    <meta property="og:image" content="https://placehold.co/1000x562/1f2833/45f248?text={{TITLE_ENC}}">
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <div id="preloader"><div class="cube-loader"></div></div>
    <header class="header">
        <div class="container nav">
            <div class="logo"><a href="/">Slope<span> 2</span></a></div>
            <nav class="nav-links">
                <a href="/all.games/">All Games</a>
                <a href="/adventure.games/">Adventure</a>
                <a href="/sports.games/">Sports</a>
                <a href="/endless-runner.games/">Endless Runner</a>
            </nav>
            <div class="header-actions">
                <form class="header-search" action="/search.html" method="get">
                    <input type="text" name="q" placeholder="Search here..." required>
                    <button type="submit" aria-label="Search"><svg viewBox="0 0 24 24" width="18" height="18" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="11" cy="11" r="8"></circle><line x1="21" y1="21" x2="16.65" y2="16.65"></line></svg></button>
                </form>
                <a href="/favorites.html" class="theme-toggle" aria-label="My Favorites" title="My Favorites"><svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg></a>
                <button class="theme-toggle" id="btn-random" aria-label="Random Game" title="Random Game"><svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><polyline points="16 3 21 3 21 8"></polyline><line x1="4" y1="20" x2="21" y2="3"></line><polyline points="21 16 21 21 16 21"></polyline><line x1="15" y1="15" x2="21" y2="21"></line><line x1="4" y1="4" x2="9" y2="9"></line></svg></button>
                <button class="theme-toggle" id="theme-toggle" aria-label="Toggle Dark/Light Mode"><svg class="icon-moon" viewBox="0 0 24 24" width="24" height="24" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M21 12.79A9 9 0 1 1 11.21 3 7 7 0 0 0 21 12.79z"></path></svg><svg class="icon-sun" viewBox="0 0 24 24" width="24" height="24" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round" style="display: none;"><circle cx="12" cy="12" r="5"></circle><line x1="12" y1="1" x2="12" y2="3"></line><line x1="12" y1="21" x2="12" y2="23"></line><line x1="4.22" y1="4.22" x2="5.64" y2="5.64"></line><line x1="18.36" y1="18.36" x2="19.78" y2="19.78"></line><line x1="1" y1="12" x2="3" y2="12"></line><line x1="21" y1="12" x2="23" y2="12"></line><line x1="4.22" y1="19.78" x2="5.64" y2="18.36"></line><line x1="18.36" y1="5.64" x2="19.78" y2="4.22"></line></svg></button>
                <div class="menu-toggle"></div>
            </div>
        </div>
    </header>
    <main>
        <section class="hero container reveal">
            <nav class="breadcrumbs"><a href="/">Home</a><span>›</span><strong>{{TITLE}}</strong></nav>
            <div class="game-badges" style="position: static; margin-bottom: 1rem; justify-content: center;">
                {{BADGES}}
            </div>
            <h1>{{TITLE}}</h1>
            <p>Experience {{TITLE}} right in your browser. Speed, precision, and high-octane fun await!</p>
            <div class="ad-space ad-leaderboard"><span>ADVERTISEMENT</span></div>
            <div class="game-container" id="game-container">
                <div class="game-overlay" id="game-overlay">
                    <img src="https://placehold.co/1000x562/1f2833/45f248?text={{TITLE_ENC}}" alt="{{TITLE}} Thumbnail" class="game-cover">
                    <button class="play-btn-large" id="play-btn-large" aria-label="Play Game"><svg viewBox="0 0 24 24" width="48" height="48" stroke="currentColor" stroke-width="2" fill="var(--clr-primary)" stroke-linecap="round" stroke-linejoin="round"><polygon points="5 3 19 12 5 21 5 3"></polygon></svg></button>
                </div>
                <iframe data-src="{{EMBED}}" id="game-iframe" title="{{TITLE}} Online" allowfullscreen></iframe>
            </div>
            <div class="game-actions container">
                <button class="action-btn" id="btn-theater" title="Theater Mode"><svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><rect x="2" y="3" width="20" height="14" rx="2" ry="2"></rect><line x1="8" y1="21" x2="16" y2="21"></line><line x1="12" y1="17" x2="12" y2="21"></line></svg><span>Expand</span></button>
                <button class="action-btn" id="btn-fullscreen" title="Fullscreen"><svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M8 3H5a2 2 0 0 0-2 2v3m18 0V5a2 2 0 0 0-2-2h-3m0 18h3a2 2 0 0 0 2-2v-3M3 16v3a2 2 0 0 0 2 2h3"></path></svg><span>Fullscreen</span></button>
                <button class="action-btn" id="btn-favorite" title="Save to Favorites"><svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><path d="M20.84 4.61a5.5 5.5 0 0 0-7.78 0L12 5.67l-1.06-1.06a5.5 5.5 0 0 0-7.78 7.78l1.06 1.06L12 21.23l7.78-7.78 1.06-1.06a5.5 5.5 0 0 0 0-7.78z"></path></svg><span>Favorite</span></button>
                <button class="action-btn" id="btn-share" title="Copy Link"><svg viewBox="0 0 24 24" width="20" height="20" stroke="currentColor" stroke-width="2" fill="none" stroke-linecap="round" stroke-linejoin="round"><circle cx="18" cy="5" r="3"></circle><circle cx="6" cy="12" r="3"></circle><circle cx="18" cy="19" r="3"></circle><line x1="8.59" y1="13.51" x2="15.42" y2="17.49"></line><line x1="15.41" y1="6.51" x2="8.59" y2="10.49"></line></svg><span>Share</span></button>
            </div>
            <div class="game-controls reveal">
                <div class="controls-block">
                    <h3>About {{TITLE}}</h3>
                    <p>{{TITLE}} is a fast-paced game that challenges your skill and timing. Perfect for quick sessions or marathon gaming!</p>
                </div>
                <div class="controls-block">
                    <h3>Game Controls</h3>
                    <ul>
                        <li><span>Steer Left</span> <span class="key">←</span> or <span class="key">A</span></li>
                        <li><span>Steer Right</span> <span class="key">→</span> or <span class="key">D</span></li>
                        <li><span>Action</span> <span class="key">Space</span></li>
                    </ul>
                </div>
            </div>
        </section>
        <article class="content-section reveal">
            <h2>Why Play {{TITLE}}?</h2>
            <p>{{TITLE}} offers high-speed excitement and neon-infused visuals that will keep you on the edge of your seat. Play now and climb the leaderboard!</p>
        </article>
    </main>
    <footer class="footer reveal">
        <div class="container footer-content">
            <div class="footer-col">
                <h3>Slope 2</h3>
                <p style="color: rgba(255,255,255,0.7); max-width: 300px;">Your premium destination for the best 3D endlessly runners.</p>
            </div>
            <div class="footer-col">
                <h3>Categories</h3>
                <div class="footer-links">
                    <a href="/arcade.games/">Arcade</a>
                    <a href="/adventure.games/">Adventure</a>
                    <a href="/sports.games/">Sports</a>
                    <a href="/endless-runner.games/">Endless Runner</a>
                    <a href="/skills.games/">Skills</a>
                    <a href="/all.games/">All Games</a>
                </div>
            </div>
            <div class="footer-col">
                <h3>Legal</h3>
                <div class="footer-links">
                    <a href="/about-us.html">About Us</a>
                    <a href="/privacy-policy.html">Privacy Policy</a>
                    <a href="/terms-of-service.html">Terms</a>
                </div>
            </div>
        </div>
        <div class="footer-bottom">
            <div class="container">&copy; <span id="current-year"></span> Slope 2.</div>
        </div>
    </footer>
    <script src="../js/main.js"></script>
</body>
</html>
"@

foreach ($game in $games) {
    $slug = Get-Slug $game.name
    $title = $game.name
    $embed = $game.embed
    $titleEnc = [uri]::EscapeDataString($title)
    
    # Generate Badges HTML
    $categories = $game.categories.Split(",")
    $badgesHtml = ""
    foreach ($cat in $categories) {
        $trimmedCat = $cat.Trim()
        $badgesHtml += "<div class='game-badge'>$trimmedCat</div>"
    }

    $folderPath = Join-Path (Get-Location) $slug
    if (!(Test-Path $folderPath)) {
        New-Item -ItemType Directory -Path $folderPath
    }
    
    $gameHtml = $template.Replace("{{TITLE}}", $title).Replace("{{SLUG}}", $slug).Replace("{{EMBED}}", $embed).Replace("{{TITLE_ENC}}", $titleEnc).Replace("{{BADGES}}", $badgesHtml)
    $filePath = Join-Path $folderPath "index.html"
    Set-Content -Path $filePath -Value $gameHtml -Encoding UTF8
    Write-Host "Created: /$slug/ with badges"
}
