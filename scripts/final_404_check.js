const fs = require('fs');
const path = require('path');

const rootDir = process.cwd();
const report = { brokenLinks: [], missingAssets: [] };

function checkPath(currentFile, target) {
    if (target.startsWith('http') || target.startsWith('//') || target === '#' || target.startsWith('mailto:') || target.startsWith('data:')) return true;
    
    let fullPath;
    if (target.startsWith('/')) {
        fullPath = path.join(rootDir, target);
    } else {
        fullPath = path.resolve(path.dirname(currentFile), target);
    }

    if (fs.existsSync(fullPath)) return true;
    
    // Check if it's a directory link that should resolve to index.html
    const dirIndex = path.join(fullPath, 'index.html');
    if (fs.existsSync(dirIndex)) return true;

    return false;
}

function auditHtml(filePath) {
    const content = fs.readFileSync(filePath, 'utf8');
    const relFile = path.relative(rootDir, filePath);

    // Filter out script content to avoid false positives with template literals
    const cleanContent = content.replace(/<script[\s\S]*?<\/script>/gi, '');

    const matches = [...cleanContent.matchAll(/ (href|src)="([^"]+)"/g)];
    for (const match of matches) {
        const attr = match[1];
        const target = match[2];
        if (!checkPath(filePath, target)) {
            if (attr === 'src') report.missingAssets.push({ file: relFile, asset: target });
            else report.brokenLinks.push({ file: relFile, link: target });
        }
    }
}

function walk(dir) {
    const files = fs.readdirSync(dir);
    for (const file of files) {
        const fullPath = path.join(dir, file);
        if (fs.statSync(fullPath).isDirectory()) {
            if (['node_modules', '.git', 'scripts', '.vscode'].includes(file)) continue;
            walk(fullPath);
        } else if (file.endsWith('.html')) {
            auditHtml(fullPath);
        }
    }
}

walk(rootDir);

console.log("=== FINAL 404 AUDIT REPORT ===");
if (report.brokenLinks.length === 0 && report.missingAssets.length === 0) {
    console.log("No 404s found! Everything is clean.");
} else {
    console.log(JSON.stringify(report, null, 2));
}
