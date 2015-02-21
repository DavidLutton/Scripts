mkdir thumb
find . -maxdepth 1 -regex  '.*\(JPG\|jpg\)$'   -exec convert "{}" -resize 300x300 thumb/"{}" \;
