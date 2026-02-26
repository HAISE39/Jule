import { createOpenAI } from '@ai-sdk/openai';
import { streamText } from 'ai';

// Configure the AI provider (Ollama or GLM-5 Cloud via OpenAI-compatible API)
const aiProvider = createOpenAI({
  baseURL: process.env.AI_BASE_URL || 'http://localhost:11434/v1',
  apiKey: process.env.AI_API_KEY || 'ollama',
});

// Set to 'ollama/glm-5:cloud' as requested or 'llama3' for default Ollama
const modelName = process.env.AI_MODEL || 'ollama/glm-5:cloud';

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = streamText({
    model: aiProvider(modelName),
    messages,
    system: "You are VELLTOOLS AI, a professional, helpful, and concise AI assistant powered by GLM-5 Cloud. Your goal is to provide high-quality assistance in a stylish and efficient manner.",
  });

  return result.toTextStreamResponse();
}
