#!/usr/bin/env python3
"""
generate_screenshots.py — DiscoverKR App Store screenshot generator

Requirements : pip install Pillow
Usage        : python3 generate_screenshots.py

How it works
------------
1. Put your raw device screenshots in   ./raw/    (PNG or JPG)
   - They are processed in sorted filename order, so name them
     01.png, 02.png, ... to control order & caption mapping.
2. Run the script.
3. Styled, App-Store-ready images land in ./output/  (01.png, 02.png, ...)

Output spec
-----------
- 1320 x 2868 px  (App Store "6.9-inch iPhone" — the required size)
- Theme gradient background (mint -> purple), centered caption,
  rounded-corner device shot with a soft drop shadow.

Edit the CONFIG block below to change captions, colors, sizes, etc.
"""

from pathlib import Path
from PIL import Image, ImageDraw, ImageFont, ImageFilter

# ----------------------------- CONFIG -----------------------------
CANVAS_W, CANVAS_H = 1320, 2868          # App Store 6.9" iPhone (required size)

BG_TOP    = (151, 201, 196)              # mint  (#97C9C4)
BG_BOTTOM = (107,  90, 140)              # purple (#6B5A8C)

CAPTION_COLOR     = (255, 255, 255)
CAPTION_FONT_SIZE = 100
CAPTION_TOP_Y     = 150                  # caption baseline start
SIDE_MARGIN       = 96                   # left/right margin for caption & shot

SHOT_TOP          = 470                  # where the device screenshot begins
SHOT_BOTTOM_GAP   = 140                  # min gap from bottom edge
CORNER_RADIUS     = 70                   # device shot rounded corners
SHADOW            = True

# Captions applied in sorted-filename order. Extra screenshots get no caption.
CAPTIONS = [
    "Discover Beautiful Korea",
    "Explore on the Map",
    "Deep Dive into Every Place",
    "Your AI Travel Guide",
    "Plan Your Perfect Trip",
    "Curated Travel Info",
]
# ------------------------------------------------------------------

HERE    = Path(__file__).resolve().parent
RAW_DIR = HERE / "raw"
OUT_DIR = HERE / "output"
EXTS    = (".png", ".jpg", ".jpeg")


def load_font(size: int) -> ImageFont.FreeTypeFont:
    candidates = [
        "/System/Library/Fonts/SFNSRounded.ttf",
        "/System/Library/Fonts/SFNS.ttf",
        "/System/Library/Fonts/Supplemental/Arial Bold.ttf",
        "/System/Library/Fonts/Helvetica.ttc",
        "/Library/Fonts/Arial Bold.ttf",
    ]
    for p in candidates:
        if Path(p).exists():
            try:
                return ImageFont.truetype(p, size)
            except Exception:
                continue
    print("⚠️  No system TrueType font found — using PIL default (small).")
    return ImageFont.load_default()


def gradient_bg(w: int, h: int, top, bottom) -> Image.Image:
    """Vertical gradient, built once per column then stretched (fast)."""
    grad = Image.new("RGB", (1, h))
    for y in range(h):
        t = y / (h - 1)
        grad.putpixel((0, y), tuple(int(top[i] * (1 - t) + bottom[i] * t) for i in range(3)))
    return grad.resize((w, h))


def rounded(img: Image.Image, radius: int) -> Image.Image:
    mask = Image.new("L", img.size, 0)
    ImageDraw.Draw(mask).rounded_rectangle([0, 0, img.size[0], img.size[1]], radius=radius, fill=255)
    out = img.convert("RGBA")
    out.putalpha(mask)
    return out


def draw_caption(canvas: Image.Image, text: str, font: ImageFont.FreeTypeFont):
    draw = ImageDraw.Draw(canvas)
    max_w = CANVAS_W - 2 * SIDE_MARGIN

    # word wrap
    lines, cur = [], ""
    for word in text.split():
        test = (cur + " " + word).strip()
        if draw.textlength(test, font=font) <= max_w:
            cur = test
        else:
            if cur:
                lines.append(cur)
            cur = word
    if cur:
        lines.append(cur)

    y = CAPTION_TOP_Y
    line_h = int(CAPTION_FONT_SIZE * 1.18)
    for line in lines:
        tw = draw.textlength(line, font=font)
        draw.text(((CANVAS_W - tw) / 2, y), line, font=font, fill=CAPTION_COLOR)
        y += line_h
    return y  # bottom of caption block


def process(raw_path: Path, index: int, font: ImageFont.FreeTypeFont):
    canvas = gradient_bg(CANVAS_W, CANVAS_H, BG_TOP, BG_BOTTOM)

    caption = CAPTIONS[index] if index < len(CAPTIONS) else ""
    if caption:
        draw_caption(canvas, caption, font)

    # load + scale the device shot to fit the available area
    shot = Image.open(raw_path).convert("RGB")
    max_w = CANVAS_W - 2 * SIDE_MARGIN
    max_h = CANVAS_H - SHOT_TOP - SHOT_BOTTOM_GAP
    scale = min(max_w / shot.width, max_h / shot.height)
    nw, nh = int(shot.width * scale), int(shot.height * scale)
    shot = shot.resize((nw, nh), Image.LANCZOS)
    shot = rounded(shot, CORNER_RADIUS)

    x = (CANVAS_W - nw) // 2
    y = SHOT_TOP

    if SHADOW:
        shadow = Image.new("RGBA", (CANVAS_W, CANVAS_H), (0, 0, 0, 0))
        ImageDraw.Draw(shadow).rounded_rectangle(
            [x, y + 22, x + nw, y + nh + 22], radius=CORNER_RADIUS, fill=(0, 0, 0, 95)
        )
        shadow = shadow.filter(ImageFilter.GaussianBlur(34))
        canvas = Image.alpha_composite(canvas.convert("RGBA"), shadow).convert("RGB")

    canvas.paste(shot, (x, y), shot)
    return canvas


def main():
    if not RAW_DIR.exists():
        RAW_DIR.mkdir(parents=True)
        print(f"📁 Created {RAW_DIR} — put your raw screenshots here and run again.")
        return

    raws = sorted(p for p in RAW_DIR.iterdir() if p.suffix.lower() in EXTS)
    if not raws:
        print(f"⚠️  No screenshots ({', '.join(EXTS)}) found in {RAW_DIR}")
        return

    OUT_DIR.mkdir(exist_ok=True)
    font = load_font(CAPTION_FONT_SIZE)

    print(f"Found {len(raws)} screenshot(s). Output → {OUT_DIR}\n")
    for i, raw_path in enumerate(raws):
        out = process(raw_path, i, font)
        out_path = OUT_DIR / f"{i + 1:02d}.png"
        out.save(out_path)
        cap = CAPTIONS[i] if i < len(CAPTIONS) else "(no caption)"
        print(f"  ✓ {out_path.name}  ←  {raw_path.name}   “{cap}”")

    print(f"\n✅ Done. {len(raws)} image(s) at {CANVAS_W}x{CANVAS_H} in {OUT_DIR}")


if __name__ == "__main__":
    main()
