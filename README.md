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
AI_BASE_URL=http://localhost:11434/v1
AI_API_KEY=ollama
AI_MODEL=ollama/glm-5:cloud
```

### 4. Run the Application

```bash
npm run dev
```

The app will be available at `http://localhost:3000`.

## Connecting to AI Backend

### Using Ollama (Local)

1. [Download and install Ollama](https://ollama.com/).
2. Pull your desired model (e.g., `ollama pull llama3`).
3. If you specifically want to use GLM-5 via Ollama, ensure you have the correct model name.
4. Set `AI_BASE_URL` to `http://localhost:11434/v1` in your `.env`.

### Using GLM-5 Cloud (Remote)

1. Get an API key from your GLM-5 provider (e.g., Zhipu AI).
2. Set the following in your `.env`:
   - `AI_BASE_URL`: The provider's API endpoint.
   - `AI_API_KEY`: Your secret API key.
   - `AI_MODEL`: the model identifier (e.g., `glm-4`).

## Technologies Used

- **Next.js 16** (App Router)
- **Tailwind CSS v4**
- **Framer Motion** (Animations)
- **Vercel AI SDK** (Streaming & State Management)
- **Lucide React** (Icons)
