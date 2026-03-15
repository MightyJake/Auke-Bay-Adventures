#!/usr/bin/env bash
# ============================================================
#  Auke Bay Adventures — Image Download Script
#  Run this ONCE from the root of the site folder.
#  It downloads all images into the uploads/ directory.
#
#  Usage:
#    chmod +x download-images.sh
#    ./download-images.sh
# ============================================================

mkdir -p uploads

dl() {
  URL="$1"
  FILE="uploads/$2"
  echo -n "  Downloading $2 ... "
  HTTP=$(curl -s -o "$FILE" -w "%{http_code}" \
    -L --max-time 20 \
    -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36" \
    --referer "https://www.aukebayadventures.com/" \
    "$URL")
  if [ "$HTTP" = "200" ] && [ -s "$FILE" ]; then
    echo "✓  ($(du -h "$FILE" | cut -f1))"
  else
    echo "✗  FAILED (HTTP $HTTP) — check URL or try manually"
    rm -f "$FILE"
  fi
}

echo ""
echo "Auke Bay Adventures — downloading site images..."
echo "================================================="

# Logo
dl "https://aukebayadventures.com/wp-content/uploads/2017/03/auke_logo-1.png"  "auke_logo.png"

# Hero / Feature images
dl "https://www.aukebayadventures.com/wp-content/uploads/2021/01/ABA_Layer_Images_1-21.jpg"                  "fleet_hero.jpg"
dl "https://aukebayadventures.com/wp-content/uploads/2017/03/AukeBayfleet_guy-fishing.jpg"                  "fleet_guy_fishing.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/photogallerytopimage-stickeen_0001_Layer-0.jpg" "stickeen_hero.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0006_Ready-to-Book_-400x284.jpg" "ready_to_book.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/03/NEW_2020_photogallery_0000_YATCHS.jpg"     "gallery_yachts.jpg"

# Yacht / Fleet images
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0002s_0004_Layer-4-400x284.jpg"  "yacht_sablefish.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0002s_0001_Layer-6-400x284.jpg"  "yacht_stickeen.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0002s_0000_Layer-7-400x284.jpg"  "yacht_58north.jpg"

# Captain
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0005s_0000_IMG8086Jacobson-400x284.jpg" "captain_steve.jpg"

# Gallery images
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0003_Fish-On-400x284.jpg"                "gallery_fishing.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0005_Whale-Watching-400x284.jpg"          "gallery_whales.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0004_Scenic-Alaska-400x284.jpg"           "gallery_scenic.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0002_Wild-400x284.jpg"                   "gallery_wild.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0001_Good-Food-Good-Friends-400x284.jpg"  "gallery_good_food.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2022/09/NEW_2020_photogallery_fishon_8-22_0000s_0012_2560_8-22-400x284.jpg" "gallery_shortraker.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2022/09/NEW_2020_photogallery_fishon_8-22_0000s_0011_2568_8-22-400x284.jpg" "gallery_fishon2.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2022/09/NEW_2020_photogallery_fishon_8-22_0000s_0013_7381_8-22-400x284.jpg" "gallery_cod.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0005s_0010_IMG_8873-400x284.jpg"         "gallery_guests.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0005s_0009_SMJ0510Jacobson-400x284.jpg"  "gallery_wildlife1.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0007s_0004_IMG_8253-400x284.jpg"         "gallery_glacier.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0007s_0000_DSC3016Jacobson-400x284.jpg"  "gallery_passage.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0004s_0009_SMJ3379Jacobson-400x284.jpg"  "gallery_bear.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0004s_0007_DSC5629Jacobson-400x284.jpg"  "gallery_wildlife2.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0004s_0006_SMJ3720Jacobson-400x284.jpg"  "gallery_coastal.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0004s_0005_SMJ4542Jacobson-400x284.jpg"  "gallery_southeast.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0006s_0010_IMG_1379-400x284.jpg"         "gallery_charter_exp.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0006s_0008_Alaska-August-09-135-400x284.jpg" "gallery_august.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0005s_0005_IMG_6755-mod-400x284.jpg"     "gallery_ocean.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0005s_0006_IMG_8214-400x284.jpg"         "gallery_scenic2.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0003s_0000_DCS4597Jacobson-400x284.jpg"  "gallery_photo1.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0003s_0001_SMJ0524Jacobson-400x284.jpg"  "gallery_coastal2.jpg"
dl "https://www.aukebayadventures.com/wp-content/uploads/2020/02/NEW_2020_photogallery_0006s_0005_DSC5406Jacobson-400x284.jpg"  "gallery_nature.jpg"

echo ""
echo "================================================="
TOTAL=$(ls uploads/ 2>/dev/null | wc -l | tr -d ' ')
echo "Complete: $TOTAL files downloaded to uploads/"
echo ""
echo "Your site is ready — open index.html in a browser."
echo ""
