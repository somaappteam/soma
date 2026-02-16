import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { OpenAI } from "https://esm.sh/openai@4.20.1"

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

serve(async (req) => {
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders })
    }

    try {
        const { transcript } = await req.json()
        const apiKey = Deno.env.get('OPENAI_API_KEY')
        if (!apiKey) {
            throw new Error('OPENAI_API_KEY not set')
        }

        const openai = new OpenAI({ apiKey: apiKey })

        // Analyze the text for difficult words and provide a score
        const chatCompletion = await openai.chat.completions.create({
            messages: [
                {
                    role: 'system', content: `You are a pronunciation coach. Analyze the following transcript. Identify difficult words for a learner. 
          Return ONLY a JSON object with the following structure:
          {
            "score": number (0-100),
            "difficult_words": ["word1", "word2"...],
            "tip": "string"
          }
          ` },
                { role: 'user', content: transcript }
            ],
            model: 'gpt-4o',
            response_format: { type: "json_object" }
        })

        const reply = JSON.parse(chatCompletion.choices[0].message.content)

        return new Response(JSON.stringify(reply), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })
    } catch (error) {
        return new Response(JSON.stringify({ error: error.message }), {
            status: 400,
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })
    }
})
