# Dockerfile for sheapgamer-discord-bot
# =================
#  Stage 1: Builder
# =================
# Stage นี้จะทำหน้าที่ติดตั้ง dependencies ทั้งหมด (รวมถึง devDependencies)
# และทำการ build โค้ด TypeScript ให้เป็น JavaScript
#
# -- FIXES --
# 1. Updated to node:20-alpine to meet better-sqlite3 requirements.
# 2. Added build-base, python3 to install native dependencies for better-sqlite3.
FROM node:20-alpine AS builder

# ตั้งค่า Working Directory ภายใน Container
WORKDIR /app

# Install build dependencies required for native modules like better-sqlite3
RUN apk add --no-cache python3 make g++

# Copy ไฟล์ package.json และ package-lock.json
# การ Copy แยกแบบนี้จะช่วยให้ Docker cache layer นี้ไว้ได้
# และจะทำการ `npm install` ใหม่ก็ต่อเมื่อไฟล์สองไฟล์นี้มีการเปลี่ยนแปลงเท่านั้น
COPY package*.json ./

# ติดตั้ง Dependencies ทั้งหมด
RUN npm install

# Copy ไฟล์ที่เหลือทั้งหมดของโปรเจกต์เข้ามาใน Container
COPY . .

# รันคำสั่ง build ที่อยู่ใน package.json (tsc)
# ผลลัพธ์ที่ได้จะอยู่ใน Folder `dist`
RUN npm run build


# ====================
#  Stage 2: Production
# ====================
# Stage นี้จะเป็น Stage สุดท้ายที่เราจะนำไปใช้งานจริง
# โดยจะดึงผลลัพธ์จากการ build และติดตั้งเฉพาะ dependencies ที่จำเป็นเท่านั้น
FROM node:20-alpine

# ตั้งค่า Working Directory
WORKDIR /app

# Copy ไฟล์ package.json และ package-lock.json
COPY package*.json ./

# ติดตั้งเฉพาะ Production Dependencies
# (--omit=dev จะไม่ติดตั้ง devDependencies)
RUN npm install --omit=dev

# Copy โค้ดที่ build เสร็จแล้วจาก Stage `builder`
# โดย Copy จาก /app/dist ของ builder มาไว้ที่ ./dist ของ Stage ปัจจุบัน
COPY --from=builder /app/dist ./dist

# Copy ไฟล์ .env.example และเปลี่ยนชื่อเป็น .env ภายใน container
# หมายเหตุ: นี่เป็นเพียงไฟล์ template เท่านั้น
# ค่าที่แท้จริงจะถูกใส่เข้ามาตอนรัน container ผ่าน docker-compose (env_file)
COPY .env ./.env

# คำสั่งที่จะรันเมื่อ Container เริ่มทำงาน
# ซึ่งจะไปเรียกใช้ `npm run start` ที่กำหนดไว้ใน package.json
CMD ["npm", "start"]
