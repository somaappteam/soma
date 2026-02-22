import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

import { errorResponse, getOpenAiClient, jsonResponse, optionsResponse } from "../_shared/openai.ts"

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return optionsResponse()
  }

  try {
    const { text } = await req.json()
    const openai = getOpenAiClient()

    const chatCompletion = await openai.chat.completions.create({
      messages: [
        { role: 'system', content: 'You are a helpful assistant that polishes text to be more grammatically correct and natural.' },
        { role: 'user', content: `Polish this text: "${text}"` },
      ],
      model: 'gpt-4o',
    })

    const reply = chatCompletion.choices[0].message.content
    return jsonResponse({ text: reply })
  } catch (error) {
    return errorResponse(error)
  }
})
