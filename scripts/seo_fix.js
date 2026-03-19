const fs = require('fs');
const path = require('path');

const rootDir = 'd:\\game clone\\slope\\slope_antgravity';
const sitemapUrl = 'https://slope2game.online/';

const GAME_TITLES = {
  '/bloodmoney': 'BLOODMONEY', '/snow-rider-2': 'Snow Rider 2', '/drift-boss': 'Drift Boss',
  '/subway-surfers': 'Subway Surfers', '/snow-rush-3d': 'Snow Rush 3D', '/slope-rider': 'Slope Rider',
  '/slide-down-slope': 'Slide Down Slope', '/slope-3-online': 'Slope 3 Online', '/slope-multiplayer': 'Slope Multiplayer',
  '/gate-rusher-2': 'Gate Rusher 2', '/two-ball-3d-dark': 'Two Ball 3D: Dark', '/slope-spooky': 'Slope Spooky',
  '/slope-2': 'Slope 2', '/slope-snowball': 'Slope Snowball', '/survive-lava-for-brainrots': 'Survive Lava for Brainrots!',
  '/fastlaners': 'FastLaners', '/fall-guyz': 'Fall Guyz', '/parkour-craft-noob-steve': 'Parkour Craft Noob Steve',
  '/dinosaur-city-hunting-destroy': 'Dinosaur City Hunting Destroy', '/extreme-ball-balancer-3d': 'Extreme Ball Balancer 3D',
  '/finns-ascent': "Finn's Ascent", '/up-together': 'Up Together', '/speed-stars': 'Speed Stars',
  '/ski-frenzy': 'Ski Frenzy', '/super-traffic-racer': 'Super Traffic Racer', '/drift-hunters-2': 'Drift Hunters 2',
  '/stunt-bike-extreme': 'Stunt Bike Extreme', '/g-switch-2': 'G-Switch 2', '/santa-run': 'Santa Run',
  '/subway-surfers-winter-holiday': 'Subway Surfers Winter Holiday'
};

function processHtmlFile(filePath) {
    let content = fs.readFileSync(filePath, 'utf8');
    const relativePath = path.relative(rootDir, filePath).replace(/\\/g, '/');
    const slug = '/' + path.dirname(relativePath);
    const isGame = !!GAME_TITLES[slug];
    
    // 1. Determine Page Name
    let pageName = "";
    if (isGame) {
        pageName = GAME_TITLES[slug];
    } else {
        const titleMatch = content.match(/<title>([^<]+)<\/title>/);
        pageName = titleMatch ? titleMatch[1].trim() : "Slope 2";
    }

    // 2. Ensure Title is name of game
    if (isGame) {
        content = content.replace(/<title>[^<]+<\/title>/, `<title>${pageName}</title>`);
    }

    // 3. Twitter Card
    if (!content.includes('name="twitter:card"')) {
        const descMatch = content.match(/name="description"\s+content="([^"]+)"/);
        const ogImgMatch = content.match(/property="og:image"\s+content="([^"]+)"/);
        const description = descMatch ? descMatch[1] : "Play the best games on Slope 2";
        const image = ogImgMatch ? ogImgMatch[1] : sitemapUrl + 'favicon.webp';
        
        const twitterTags = `
    <meta name="twitter:card" content="summary_large_image">
    <meta name="twitter:title" content="${pageName}">
    <meta name="twitter:description" content="${description}">
    <meta name="twitter:image" content="${image}">`;
        content = content.replace(/<\/head>/, `${twitterTags}\n</head>`);
    }

    // 4. Breadcrumb Schema for Games
    if (isGame && !content.includes('"@type": "BreadcrumbList"')) {
        const breadcrumbSchema = `
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "BreadcrumbList",
      "itemListElement": [{
        "@type": "ListItem",
        "position": 1,
        "name": "Home",
        "item": "${sitemapUrl}"
      },{
        "@type": "ListItem",
        "position": 2,
        "name": "${pageName}"
      }]
    }
    </script>`;
        content = content.replace(/<\/head>/, `${breadcrumbSchema}\n</head>`);
    }

    // 5. Game Schema for Games
    if (isGame && !content.includes('"@type": "SoftwareApplication"')) {
        const descMatch = content.match(/name="description"\s+content="([^"]+)"/);
        const description = descMatch ? descMatch[1] : "Play the best games on Slope 2";
        
        const gameSchema = `
    <script type="application/ld+json">
    {
      "@context": "https://schema.org",
      "@type": "SoftwareApplication",
      "name": "${pageName}",
      "operatingSystem": "Any",
      "applicationCategory": "GameApplication",
      "description": "${description}",
      "offers": {
        "@type": "Offer",
        "price": "0",
        "priceCurrency": "USD"
      },
      "aggregateRating": {
        "@type": "AggregateRating",
        "ratingValue": "4.8",
        "ratingCount": "1250"
      }
    }
    </script>`;
        content = content.replace(/<\/head>/, `${gameSchema}\n</head>`);
    }

    fs.writeFileSync(filePath, content);
}

function walk(dir) {
    const files = fs.readdirSync(dir);
    files.forEach(file => {
        const fullPath = path.join(dir, file);
        if (fs.statSync(fullPath).isDirectory()) {
            if (file !== 'node_modules' && file !== '.git' && file !== 'scripts') walk(fullPath);
        } else if (file === 'index.html' || file === '404.html') {
            processHtmlFile(fullPath);
        }
    });
}

walk(rootDir);
console.log("SEO Update Complete");
