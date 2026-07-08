import requests
import os

images = {
    "khandvi.jpg": "https://upload.wikimedia.org/wikipedia/commons/4/4b/Khandvi_Gujarati_Snack.jpg",
    "chhole_bhature.jpg": "https://upload.wikimedia.org/wikipedia/commons/c/cb/Chole_Bhature_-_New_Delhi_2012.jpg",
    "pancakes.jpg": "https://upload.wikimedia.org/wikipedia/commons/4/43/Blueberry_pancakes_%281%29.jpg",
    "dhokla.jpg": "https://upload.wikimedia.org/wikipedia/commons/8/87/Dhokla.jpg"
}

headers = {
    "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.124 Safari/537.36"
}

os.makedirs("static/images", exist_ok=True)

for filename, url in images.items():
    print(f"Downloading {filename}...")
    response = requests.get(url, headers=headers)
    if response.status_code == 200:
        with open(f"static/images/{filename}", "wb") as f:
            f.write(response.content)
        print(f"Saved {filename}")
    else:
        print(f"Failed to download {filename}: {response.status_code}")
