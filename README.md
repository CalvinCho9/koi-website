# Knowing Others to Inspire — website

Static site for KOI, a student-led 501(c)(3) nonprofit promoting neurodiversity
education. Plain HTML + one CSS file. No build step, no framework.

```
koi-site/
├── index.html          # Home — mission + programs
├── book.html           # The Neurodiverse Glossary, donations, translations, reviews
├── resources.html      # Videos, articles, networks
├── css/styles.css      # The whole design system
├── assets/             # Images (populated by the download script)
├── assets-manifest.csv # local filename → Wix CDN id
├── scripts/
│   └── download-assets.sh
├── CNAME               # custom domain for GitHub Pages
├── .nojekyll           # skip Jekyll processing
└── MIGRATION_PLAYBOOK.md   ← start here
```

## Quick start

```bash
# 1. pull the images
bash scripts/download-assets.sh

# 2. preview locally
python3 -m http.server 8000
#    → open http://localhost:8000
```

## Edit

- **Colors / fonts:** `css/styles.css`, `:root` block at the top.
- **Text:** directly in the three `.html` files.
- **Header/footer:** duplicated across the three pages — edit all three when changing
  nav or footer (it's only three files).

Full migration + deploy steps are in **MIGRATION_PLAYBOOK.md**.
