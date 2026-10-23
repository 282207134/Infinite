"""Trim Pixso export effects and encode local assets as high-quality WebP."""
from pathlib import Path
from PIL import Image

root = Path(__file__).resolve().parents[1]
for path in (root / 'assets/images').glob('*.png'):
    image = Image.open(path).convert('RGBA')
    # Pixso vectors include large, nearly transparent shadow extents.
    bounds = image.getchannel('A').point(lambda a: 255 if a > 120 else 0).getbbox()
    image = image.crop(bounds) if bounds else image
    image.save(path.with_suffix('.webp'), quality=94, method=6)
    path.unlink()
