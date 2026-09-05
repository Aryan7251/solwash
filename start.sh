#!/usr/bin/env bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export PATH="/home/linux/.local/bin:/home/linux/.local/node/bin:$PATH"

echo "Starting SolWash services..."

# 1. Start Backend Server (Port 5000)
if lsof -Pi :5000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo " Backend already running on port 5000"
else
    echo " Starting Backend Server (port 5000)..."
    cd "$ROOT_DIR/backend"
    nohup node src/server.js > "$ROOT_DIR/backend/server.log" 2>&1 &
fi

# 2. Start Admin Panel (Port 3000)
if lsof -Pi :3000 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo " Admin Panel already running on port 3000"
else
    echo " Starting Admin Panel (port 3000)..."
    cd "$ROOT_DIR/admin"
    nohup node serve.js > "$ROOT_DIR/admin/admin.log" 2>&1 &
fi

# 3. Start Frontend Web Preview (Port 3001)
if lsof -Pi :3001 -sTCP:LISTEN -t >/dev/null 2>&1 ; then
    echo " Frontend Web Preview already running on port 3001"
else
    echo " Starting Frontend Web Preview (port 3001)..."
    cd "$ROOT_DIR/frontend/web_preview"
    nohup node serve.js > "$ROOT_DIR/frontend/web_preview/web_preview.log" 2>&1 &
fi

echo "========================================="
echo " SolWash servers are up and running!"
echo " Backend API:     http://localhost:5000"
echo " Admin Panel:     http://localhost:3000"
echo " Mobile Preview:  http://localhost:3001"
echo "========================================="
