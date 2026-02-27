import { ollama } from 'ollama-ai-provider';
import { streamText } from 'ai';

// Set to 'glm-5:cloud' as requested
const modelName = process.env.AI_MODEL || 'glm-5:cloud';

export async function POST(req: Request) {
  const { messages } = await req.json();

  const result = streamText({
    model: ollama(modelName),
    messages,
    system: "You are VELLTOOLS AI, a professional, helpful, and concise AI assistant. Your goal is to provide high-quality assistance in a stylish and efficient manner.",
  });

  return result.toTextStreamResponse();
}
