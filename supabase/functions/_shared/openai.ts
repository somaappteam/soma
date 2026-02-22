import { OpenAI } from "https://esm.sh/openai@4.20.1"

export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
}

export function jsonResponse(payload: unknown, status = 200): Response {
  return new Response(JSON.stringify(payload), {
    status,
    headers: { ...corsHeaders, 'Content-Type': 'application/json' },
  })
}

export function optionsResponse(): Response {
  return new Response('ok', { headers: corsHeaders })
}

export function getOpenAiClient(): OpenAI {
  const apiKey = Deno.env.get('OPENAI_API_KEY')
  if (!apiKey) {
    throw new Error('OPENAI_API_KEY not set')
  }
  return new OpenAI({ apiKey })
}

export function errorResponse(error: unknown): Response {
  const message = error instanceof Error ? error.message : 'Unknown error'
  return jsonResponse({ error: message }, 400)
}
