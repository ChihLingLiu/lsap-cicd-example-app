FROM node:20-alpine

WORKDIR /app

# 先裝依賴（利用 cache）
COPY package*.json ./
RUN npm ci --omit=dev

# 再拷貝程式碼
COPY . .

EXPOSE 3000

CMD ["node", "server.js"]
