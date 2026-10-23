"""Regenerate native icons from the app's two interlocking chevrons."""
import json
from pathlib import Path
from PIL import Image, ImageDraw

root = Path(__file__).resolve().parents[1]
icon = Image.new('RGB', (1024, 1024), '#303f4b')
draw = ImageDraw.Draw(icon)
draw.polygon([(440, 270), (190, 512), (440, 754), (512, 680), (338, 512), (512, 344)], fill='#92cafb')
draw.polygon([(584, 270), (512, 344), (686, 512), (512, 680), (584, 754), (834, 512)], fill='#ffffff')
folder = root / 'ios/Runner/Assets.xcassets/AppIcon.appiconset'
for item in json.loads((folder / 'Contents.json').read_text())['images']:
    if 'filename' in item:
        size = round(float(item['size'].split('x')[0]) * float(item['scale'].rstrip('x')))
        icon.resize((size, size), Image.Resampling.LANCZOS).save(folder / item['filename'])
for path in (root / 'android/app/src/main/res').glob('mipmap-*/ic_launcher.png'):
    size = Image.open(path).size
    icon.resize(size, Image.Resampling.LANCZOS).save(path)
