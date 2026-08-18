#!/bin/bash
set -e

OLD_PKG="com.sivalabs"
NEW_PKG="com.abhilashpanigrahi"
OLD_PATH="com/sivalabs"
NEW_PATH="com/abhilashpanigrahi"

echo "==> Step 1: Moving Java source directories for each module"
for module in api-gateway bookstore-webapp catalog-service notification-service order-service; do
  for src_root in "$module/src/main/java" "$module/src/test/java"; do
    if [ -d "$src_root/$OLD_PATH" ]; then
      echo "   Moving $src_root/$OLD_PATH -> $src_root/$NEW_PATH"
      mkdir -p "$src_root/$(dirname "$NEW_PATH")"
      git mv "$src_root/$OLD_PATH" "$src_root/$NEW_PATH"
    fi
  done
done

echo "==> Step 2: Updating package/import statements in all .java files"
find . -type f -name "*.java" -exec sed -i "s/${OLD_PKG//./\\.}/${NEW_PKG}/g" {} +

echo "==> Step 3: Updating groupId in all pom.xml files"
# Only replaces the <groupId>com.sivalabs...</groupId> lines, leaves other groupIds (e.g. org.postgresql) untouched
find . -type f -name "pom.xml" -exec sed -i "s#<groupId>com\.sivalabs\(\.[a-z]*\)\?</groupId>#<groupId>${NEW_PKG}\1</groupId>#g" {} +

echo "==> Step 4: Fixing leftover text references (contact info, support email, README)"
# Contact block in OpenAPI configs
find . -type f -name "*.java" -exec sed -i \
  -e 's/new Contact()\.name("SivaLabs")\.email("sivalabs@sivalabs\.in")/new Contact().name("Abhilash Panigrahi").email("abhilash@example.com")/g' \
  {} +

# Support email in notification-service application.properties
if [ -f "notification-service/src/main/resources/application.properties" ]; then
  sed -i 's/notification\.support-email=siva@sivalabs\.com/notification.support-email=support@example.com/' \
    "notification-service/src/main/resources/application.properties"
fi

# README references
if [ -f "README.md" ]; then
  sed -i \
    -e 's#https://github.com/sivaprasadreddy/spring-boot-microservices-course\.git#https://github.com/abhilash-panigrahi/KitaabVerse.git#g' \
    README.md
  echo "   NOTE: README.md still has a 'SivaLabs Blog' links section (lines ~131-136)."
  echo "   These are attribution/credit links to the original author's blog, not code references."
  echo "   Decide manually whether to keep them as credit to the original course, or remove them."
fi

echo ""
echo "==> Done. Now review the changes:"
echo "   git status"
echo "   git diff --stat"
echo ""
echo "Then build each module to make sure nothing broke, e.g.:"
echo "   cd order-service && ./mvnw -ntp verify"
echo ""
echo "IMPORTANT: your Docker image name properties (already using abhilashpanigrahi) are untouched by this script."
echo "Double check each pom.xml still has the correct <dockerImageName> you set earlier."
