import sqlite3
import os

def update_images():
    db_path = 'airecipe.db'
    if not os.path.exists(db_path):
        print(f"Error: {db_path} not found.")
        return

    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    updates = [
        ("Gujarati Khandvi", "http://192.168.1.28:8000/static/images/khandvi.png"),
        ("Chole Bhature", "http://192.168.1.28:8000/static/images/chhole_bhature.png"),
        ("Pancakes with Maple Syrup", "http://192.168.1.28:8000/static/images/pancakes.png"),
        ("Dhokla", "http://192.168.1.28:8000/static/images/dhokla.png"),
        ("French Toast", "http://192.168.1.28:8000/static/images/pancakes_user.jpg")
    ]

    for title, url in updates:
        cursor.execute("UPDATE recipes SET image_url = ? WHERE title = ?", (url, title))
        if cursor.rowcount > 0:
            print(f"Updated {title}")
        else:
            print(f"Recipe not found: {title}")

    conn.commit()
    conn.close()

if __name__ == "__main__":
    update_images()
