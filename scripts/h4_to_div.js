const fs = require('fs');
const path = require('path');

const rootDir = process.cwd();

function walk(dir) {
    const files = fs.readdirSync(dir);
    for (const file of files) {
        const fullPath = path.join(dir, file);
        if (fs.statSync(fullPath).isDirectory()) {
            if (['node_modules', '.git', 'scripts'].includes(file)) continue;
            walk(fullPath);
        } else if (file.endsWith('.html')) {
            let content = fs.readFileSync(fullPath, 'utf8');
            const original = content;
            
            // Match <h4 ...>Published by Admin</h4>
            // We use a regex that handles the style attribute we saw earlier
            const regex = /<h4 style="margin:0 0 0\.5rem 0;color:var\(--clr-heading\);">Published by Admin<\/h4>/g;
            content = content.replace(regex, '<div class="author-name" style="margin:0 0 0.5rem 0;color:var(--clr-heading);font-weight:bold;">Published by Admin</div>');
            
            if (content !== original) {
                fs.writeFileSync(fullPath, content, 'utf8');
                console.log(`Updated: ${fullPath}`);
            }
        }
    }
}

walk(rootDir);
console.log("H4 to DIV transformation complete.");
