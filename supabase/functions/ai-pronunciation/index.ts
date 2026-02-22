import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

import { errorResponse, getOpenAiClient, jsonResponse, optionsResponse } from "../_shared/openai.ts"

serve(async (req) => {
  if (req.method === 'OPTIONS') {
    return optionsResponse()
  }

  try {
    const { transcript } = await req.json()
    const openai = getOpenAiClient()

    const chatCompletion = await openai.chat.completions.create({
      messages: [
        {
          role: 'system', content: `You are a pronunciation coach. Analyze the following transcript. Identify difficult words for a learner.
Return ONLY a JSON object with the following structure:
{
  "score": number (0-100),
  "difficult_words": ["word1", "word2"...],
  "tip": "string"
}`,
        },
        { role: 'user', content: transcript },
      ],
      model: 'gpt-4o',
      response_format: { type: "json_object" },
    })

    const reply = JSON.parse(chatCompletion.choices[0].message.content)
    return jsonResponse(reply)
  } catch (error) {
    return errorResponse(error)
  }
})
