# Build Image and Push to Github Registry
### GitHub Generate Token(classic)
1. สร้าง Personal Access Token (PAT)
คุณต้องใช้ Token นี้แทนรหัสผ่านเพื่อ login เข้า GitHub Registry

1. ไปที่หน้าตั้งค่า Token ของ GitHub: [github.com/settings/tokens](https://github.com/settings/tokens)

1. คลิก Generate new token และเลือก Generate new token (classic)

1. Note: ตั้งชื่อ Token ให้จำง่าย เช่น docker-registry-token

1. Expiration: ตั้งวันหมดอายุตามต้องการ (แนะนำ 30 หรือ 90 วัน)

1. Select scopes: ติ๊กเลือกสิทธิ์ที่จำเป็นดังนี้:

   ✅ write:packages (สำหรับ Push image)

   ✅ read:packages (สำหรับ Pull image)

   ✅ delete:packages (เผื่อไว้สำหรับลบ image)

1. คลิก Generate token ที่ด้านล่างสุด

1. คัดลอก Token ที่ได้เก็บไว้ในที่ปลอดภัยทันที เพราะจะเห็นได้แค่ครั้งเดียว
### Login and push image (หาข้อมูลเรื่อง Build Multi-Arch for arm64, amd64)
```
docker login ghcr.io -u <github-username> #enter -> input token github
```
```
 docker tag sheapgamer-discord-bot-my-free-game-bot ghcr.io/<github-username-lowercase>/sheapgamer-discord-bot-my-free-game-bot:latest
```
```
docker push ghcr.io/<github-username-lowercase>/sheapgamer-discord-bot-my-free-game-bot:latest 
```


# Pull Image
```
docker run -d --name my-free-game-bot --env-file "C:\path\to\your\.env" ghcr.io/<github-username-lowercase>/sheapgamer-discord-bot-my-free-game-bot:latest
```
หรือ
```
docker run -d \
  --name my-free-game-bot \
  -e DISCORD_BOT_TOKEN=YOUR_BOT_TOKEN_HERE \
  -e DISCORD_CHANNEL_ID=YOUR_CHANNEL_ID_HERE \
  -e RSS_FEED_URL=https://rss.app/feeds/COiTZRnT26oDqrJf.xml \
  ghcr.io/<github-username-lowercase>/sheapgamer-discord-bot-my-free-game-bot:latest

```


# **SheapGamer RSS Feed Discord Bot**

This Discord bot automatically fetches the latest articles from a specified RSS feed and posts them to a designated Discord channel

This purpose to read RSS feed from SheapGamer channel but you can configure it
to read from any RSS feed your desired.

## **Features** :rocket:

* **Automated RSS Fetching:** Periodically checks a configurable RSS feed URL (default: https://rss.app/feeds/COiTZRnT26oDqrJf.xml) which is SheapGamer RSS
* **Persistent Tracking:** Uses a local last\_processed\_guid.json file to store the GUID (Globally Unique Identifier) of the last successfully posted RSS item, preventing duplicate posts across bot restarts.  
* **One-Day Filter:** Ignores any RSS posts that are older than 24 hours to prevent posting outdated content.  
* **Chronological Posting:** New items are posted in ascending order by date, ensuring the oldest new content appears first.  
* **Concise Discord Embeds:** Each new post is formatted as a Discord embed containing only:  
  * The article's **Title** (clickable, linking to the original article).  
  * The article's **Featured Image** (if available in the RSS feed).  
  * A **Timestamp** (from the RSS item's publication date).  

## **Getting Started**

Follow these steps to set up and run your Discord bot.

### **Prerequisites** :wrench:

* **Node.js (v18.x or higher recommended):** Download and install from [nodejs.org](https://nodejs.org/). This includes npm.  
* A **Discord Account** and a **Discord Server** where you have permissions to manage channels and invite bots.

### **Discord Bot Setup** 🤖

1. **Create a New Application:**  
   * Go to the [Discord Developer Portal](https://discord.com/developers/applications).  
   * Click "New Application" and give your bot a name (e.g., SheapGamer RSS Bot).  
2. **Add a Bot User:**  
   * Navigate to the "Bot" tab on the left sidebar.  
   * Click "Add Bot" and then "Yes, do it\!".  
3. **Copy Bot Token:**  
   * Under the "Token" section, click "Copy". **DO NOT LEAK YOUR TOKEN ANYWHERE\!** 
   keep it in note or something
4. **Configure Gateway Intents:**  
   * Scroll down to "Privileged Gateway Intents".  
   * For this bot's current functionality, you likely **don't need** to enable "PRESENCE INTENT" or "MESSAGE CONTENT INTENT". If you plan to add commands later, you might need to enable Message Content Intent.  
5. **Invite Your Bot to Your Server:**  
   * Go to the "OAuth2" tab, then "URL Generator".  
   * Under "SCOPES", select bot.  
   * Under "BOT PERMISSIONS", select at least this permission:  
     * Send Messages  
     * Embed Links (Crucial for the rich messages)  
   * Copy the generated URL. Paste it into your browser, select the server you want the bot to join, and authorize it.  
6. **Get Channel ID:**  
   * In your Discord server, go to "User Settings" (bottom left, gear icon).  
   * Navigate to "App Settings" \-\> "Advanced".  
   * Enable "Developer Mode".  
   * Right-click on the Discord channel where you want the bot to post updates, and select "Copy ID". This is your DISCORD\_CHANNEL\_ID.

### **Project Setup** :computer:

1. **Clone this project**

2. **Install Dependencies:**
   `$ npm install`

3. **Create .env File:**
   - Create a `.env` file in the root of the project. You can copy `.env.example` if it exists.
   - Add the following environment variables to your `.env` file:
    ```
     DISCORD_BOT_TOKEN="YOUR_BOT_TOKEN_HERE"
     DISCORD_CHANNEL_ID="YOUR_CHANNEL_ID_HERE"
     RSS_FEED_URL="https://rss.app/feeds/COiTZRnT26oDqrJf.xml"
    ```

    - **Replace `YOUR_BOT_TOKEN_HERE`** with the token you copied from the Discord Developer Portal.
    - **Replace `YOUR_CHANNEL_ID_HERE`** with the channel ID you copied from your Discord server.
    - You can optionally change `RSS_FEED_URL` to use a different feed.

### **Running the Bot** :robot:

You can run the bot in either development or production mode.

**Development Mode**

For development, the bot will automatically restart when you make changes to the code.

`$ npm run dev`

**Production Mode**

For production, you'll first need to build the TypeScript source code into JavaScript.

1.  **Build the project:**
    `$ npm run build`

2.  **Start the bot:**
    `$ npm start`

The bot should now log in to Discord. You will see console messages indicating that it's checking the RSS feed and either posting new items or reporting that no new eligible items were found.

### **License**

This project is licensed under the MIT License - see the LICENSE file (if you choose to create one) for details. (Typically, for small open-source projects, a LICENSE file is included in the root directory, containing the full text of the chosen license).

## Project Structure

- `src/config/` - Configuration files and environment management
- `src/commands/` - Discord command modules
- `src/events/` - Discord event handlers
- `src/services/` - Reusable services (e.g., RSS, database)
- `src/utils/` - Utility functions
