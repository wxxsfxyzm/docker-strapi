#!/bin/sh
set -ea

if [ "$*" = "strapi" ]; then

  if [ ! -f "package.json" ]; then

    DATABASE_CLIENT=${DATABASE_CLIENT:-sqlite}

    EXTRA_ARGS=${EXTRA_ARGS}

    echo "Using strapi $(strapi version)"
    echo "No project found at /srv/app. Creating a new strapi project ..."

    DOCKER=true strapi new . --no-run \
      --dbclient=$DATABASE_CLIENT \
      --dbhost=$DATABASE_HOST \
      --dbport=$DATABASE_PORT \
      --dbname=$DATABASE_NAME \
      --dbusername=$DATABASE_USERNAME \
      --dbpassword=$DATABASE_PASSWORD \
      --dbssl=$DATABASE_SSL \
      $EXTRA_ARGS

  elif [ ! -d "node_modules" ] || [ ! "$(ls -qAL node_modules 2>/dev/null)" ]; then

      echo "Node modules not installed. Installing using npm ..."
      npm install --only=prod --silent

  fi

  echo "Adding your configuration to the admin UI..."
  if [ "$NEED_CHINESE" = "true" ]; then
    SOURCE_FILE="/srv/app/src/admin/app.example.js"
    TARGET_FILE="/srv/app/src/admin/app.js"
    # 移除 'zh-Hans' 前面的注释
    sed -i 's#// \'zh-Hans\'#\'zh-Hans\'#' "$SOURCE_FILE"
    mv "$SOURCE_FILE" "$TARGET_FILE"

  fi

  if [ "$NODE_ENV" = "production" ]; then
    echo "Building your admin UI ..."
    npm run build
    STRAPI_MODE="start"
  elif [ "$NODE_ENV" = "development" ]; then
    STRAPI_MODE="develop"
  fi

  echo "Starting your app (with ${STRAPI_MODE:-develop})..."
  exec strapi "${STRAPI_MODE:-develop}"

else
  exec "$@"
fi