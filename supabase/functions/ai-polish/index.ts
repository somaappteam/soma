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
        const { text } = await req.json()
        const apiKey = Deno.env.get('OPENAI_API_KEY')
        if (!apiKey) {
            throw new Error('OPENAI_API_KEY not set')
        }

        const openai = new OpenAI({ apiKey: apiKey })

        const chatCompletion = await openai.chat.completions.create({
            messages: [
                { role: 'system', content: 'You are a helpful assistant that polishes text to be more grammatically correct and natural.' },
                { role: 'user', content: `Polish this text: "${text}"` }
            ],
            model: 'gpt-4o',
        })

        const reply = chatCompletion.choices[0].message.content

        return new Response(JSON.stringify({ text: reply }), {
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })
    } catch (error) {
        return new Response(JSON.stringify({ error: error.message }), {
            status: 400,
            headers: { ...corsHeaders, 'Content-Type': 'application/json' },
        })
    }
})
