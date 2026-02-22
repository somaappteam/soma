import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

import { errorResponse, getOpenAiClient, jsonResponse, optionsResponse } from "../_shared/openai.ts"

const maxInputLength = 600
const maxOutputLength = 1200

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return optionsResponse()
  }

  try {
    const { text, target_language } = await req.json()

    if (typeof text !== 'string' || text.trim().length === 0) {
      return jsonResponse({ error: 'text is required' }, 400)
    }
    if (text.length > maxInputLength) {
      return jsonResponse({ error: `text exceeds max length (${maxInputLength})` }, 400)
    }
    if (typeof target_language !== 'string' || target_language.trim().length === 0) {
      return jsonResponse({ error: 'target_language is required' }, 400)
    }

    const openai = getOpenAiClient()

    const chatCompletion = await openai.chat.completions.create({
      messages: [
        {
          role: 'system',
          content: `You are a helpful translator. Translate text to ${target_language}. Return translated text only.`,
        },
        { role: 'user', content: text },
      ],
      model: 'gpt-4o',
    })

    const reply = chatCompletion.choices[0].message.content?.trim() ?? ''
    if (reply.length === 0) {
      return jsonResponse({ error: 'empty model output' }, 502)
    }
    if (reply.length > maxOutputLength) {
      return jsonResponse({ error: `translated output exceeds max length (${maxOutputLength})` }, 502)
    }

    return jsonResponse({ text: reply })
  } catch (error) {
    return errorResponse(error)
  }
})
