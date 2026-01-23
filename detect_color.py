from PIL import Image
import sys

try:
    im = Image.open(r"d:\projects\ignite\medexplain_ai\assets\images\splash_logo.jpg")
    rgb_im = im.convert('RGB')
    r, g, b = rgb_im.getpixel((0, 0))
    print(f'Color detected: #{r:02x}{g:02x}{b:02x}')
except Exception as e:
    print(f"Error: {e}")
