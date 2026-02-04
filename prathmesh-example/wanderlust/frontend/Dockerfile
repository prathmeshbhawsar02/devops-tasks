# ---------- 1️⃣ Builder ----------
FROM node:lts-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install --ignore-scripts


COPY . .

RUN npm run build



FROM node:lts-alpine

WORKDIR /app

COPY --from=builder /app/dist ./dist
RUN npm install -g serve

EXPOSE 3000

CMD ["serve", "-s", "dist", "-l", "3000"]
