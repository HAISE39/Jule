# VELLTOOLS AI Chat Assistant

A professional AI chat interface built with Next.js 16, React 19, and Tailwind CSS v4.

## Features

- **Modern UI:** Stylish purple theme with Framer Motion animations.
- **AI Integration:** Seamless connection to Ollama or GLM-5 Cloud via OpenAI-compatible API.
- **Chat History:** Persistent chat history using local storage.
- **Responsive Design:** Optimized for both desktop and mobile devices.

## Setup Instructions

### 1. Prerequisites

- Node.js 18+
- Ollama installed locally (optional, for local AI)

### 2. Installation

```bash
npm install
```

### 3. Configuration

Create a `.env` file in the root directory (you can copy from `.env.example`):

```env
AI_MODEL=glm-5:cloud
```

### 4. Run the Application

```bash
npm run dev
```

The app will be available at `http://localhost:3000`.

## Connecting to AI Backend

### Using Ollama (Local)

1. [Download and install Ollama](https://ollama.com/).
2. Pull the VELLTOOLS model:
   ```bash
   ollama pull glm-5:cloud
   ```
3. Ensure Ollama is running in the background.

## Technologies Used

- **Next.js 16** (App Router)
- **Tailwind CSS v4**
- **Framer Motion** (Animations)
- **Vercel AI SDK** (Streaming & State Management)
- **Lucide React** (Icons)
