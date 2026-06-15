# KOI site migration — playbook

This folder is a complete, working static rebuild of **knowingotherstoinspire.com**
(Home, Book, Resources), ready to finish in Claude Code and deploy free on GitHub
Pages. The text content and the layout are already done. What's left is pulling the
real images, filling three small gaps, and shipping.

---

## The methodology (how this was pulled, so you can trust it)

The migration follows five phases. Phases 1–2 are done; you drive 3–5.

1. **Inventory** — every page (`/`, `/book`, `/resources`) was read and its text,
   links, and image references catalogued. ✅ done
2. **Rebuild** — content was poured into clean semantic HTML + one CSS file, no Wix,
   no build step, no JavaScript framework. ✅ done
3. **Pull assets** — download the original-resolution images off Wix's CDN. ← you
4. **Fill gaps** — three things can't be scraped from the rendered pages (below). ← you
5. **Deploy + cut over DNS** — push to GitHub Pages, point the domain. ← you

---

## Phase 3 — Pull the image assets

Every image lives on Wix's CDN. The trick: Wix serves resized/cropped versions
through a `/v1/fill/...` transform in the URL. Strip that and request the bare
`https://static.wixstatic.com/media/<ID>` and you get the **original upload at full
resolution**. The script does this for all 29 images.

```bash
bash scripts/download-assets.sh
```

Files land in `assets/` with friendly names that already match the HTML
(`logo.png`, `home-glossary.png`, `donation-benson.png`, …). Open `index.html` in a
browser afterward and the images appear. Anything that fails to download is printed
with its URL so you can grab it by hand.

> The mapping of friendly name → Wix ID is in `assets-manifest.csv` if you need it.

---

## Phase 4 — Fill the three gaps

These can't be recovered from the public pages — pull them from your Wix editor:

1. **Video embed URLs** (`resources.html`). Six videos are described but their
   YouTube links aren't in the page. In the Wix editor, click each video → copy its
   URL, then in `resources.html` swap the grey `<span class="placeholder">…</span>`
   for `<iframe src="https://www.youtube.com/embed/VIDEO_ID" allowfullscreen></iframe>`.
2. **Social links** (footer, all pages). The "Connect with us" icon points to `#`.
   Replace with your real Instagram/other URL. Search the files for `href="#"`.
3. **Book preview carousel** (optional). The original `/book` page had a 21-image
   page-flip carousel. The rebuild shows a single cover instead. If you want the
   carousel back, that's the one piece worth asking Claude Code to build.

### Hand-off prompt for Claude Code

Open this folder in Claude Code and paste:

> This is a static rebuild of our nonprofit site (plain HTML + one CSS file, no build
> step). Please: (1) run `scripts/download-assets.sh` and confirm every image
> downloaded; (2) I'll give you six YouTube URLs — wire them into the video grid in
> `resources.html`, replacing the placeholder spans with responsive iframes; (3)
> replace the `href="#"` social link in every footer with our Instagram URL:
> [paste it]; (4) do a pass for broken links and missing alt text; (5) start a local
> server so I can preview. Keep the existing design system and don't add a framework.

---

## Phase 5 — Deploy to GitHub Pages, then cut over the domain

### Push the site
1. Create a GitHub repo (e.g. `koi-site`). Public is required for free Pages.
2. Push these files to the repo root (not a subfolder):
   ```bash
   git init && git add . && git commit -m "KOI static site"
   git branch -M main
   git remote add origin https://github.com/YOUR_USER/koi-site.git
   git push -u origin main
   ```
3. Repo **Settings → Pages** → Source: *Deploy from a branch* → `main` / root → Save.
4. Confirm it works at `https://YOUR_USER.github.io/koi-site/` first.

### Add the custom domain (do this BEFORE touching DNS)
5. Settings → Pages → **Custom domain** → `www.knowingotherstoinspire.com` → Save.
   (A `CNAME` file with this domain is already included, so it'll persist.)

### Transfer the domain off Wix + point DNS
6. In Wix: Domains → Domain Actions → **Transfer away from Wix**; Wix emails you the
   EPP/authorization code. Take it to a cheaper registrar (Cloudflare, Porkbun,
   Namecheap) to complete the transfer. *(Note: domains can't transfer within 60 days
   of registration or a contact-info change.)*
7. At the new registrar's DNS, set:
   - **A records** on the apex (`@`) → `185.199.108.153`, `185.199.109.153`,
     `185.199.110.153`, `185.199.111.153`
   - **CNAME** on `www` → `YOUR_USER.github.io`
   - Remove any leftover Wix A/CNAME records — stray records block GitHub's HTTPS cert.
8. Back in Settings → Pages, tick **Enforce HTTPS** once DNS resolves (can take up to
   24h). Done.

> If you use **Wix business email** on this domain, re-add its MX records at the new
> registrar or email will stop working.

---

## What changed from the original (on purpose)

- One shared stylesheet, semantic HTML, ~zero JS — fast, accessible, easy to edit.
- A real design system (Fraunces + Mulish, a koi/water/neurodiversity-spectrum
  palette) instead of the Wix theme. Tweak colors in `css/styles.css` `:root`.
- The book carousel was simplified to a single cover (see Phase 4 if you want it back).

## Verify before you call it done
- [ ] All 29 images present in `assets/` and visible on each page
- [ ] Six video iframes wired up
- [ ] Social link points to the real account
- [ ] Amazon button works; email link works
- [ ] Site loads at `YOUR_USER.github.io/koi-site` then at the custom domain
- [ ] "Enforce HTTPS" is on and the padlock shows
