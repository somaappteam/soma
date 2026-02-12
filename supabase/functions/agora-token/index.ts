import { serve } from "https://deno.land/std@0.208.0/http/server.ts";
import { createClient } from "https://esm.sh/@supabase/supabase-js@2";
import { RtcRole, RtcTokenBuilder } from "npm:agora-access-token@2.0.4";

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
};

function mapUserIdToAgoraUid(userId: string): number {
  let hash = 0x811c9dc5;
  for (const byte of new TextEncoder().encode(userId)) {
    hash ^= byte;
    hash = Math.imul(hash, 0x01000193) >>> 0;
  }
  hash = hash & 0x7fffffff;
  return hash === 0 ? 1 : hash;
}

serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response("ok", { headers: corsHeaders });
  }

  const required = [
    "AGORA_APP_ID",
    "AGORA_APP_CERT",
    "SUPABASE_URL",
    "SUPABASE_ANON_KEY",
  ];
  const missing = required.filter((name) => !Deno.env.get(name));
  if (missing.length > 0) {
    return Response.json(
      { error: `Missing env: ${missing.join(", ")}` },
      { status: 500, headers: corsHeaders },
    );
  }

  const supabase = createClient(
    Deno.env.get("SUPABASE_URL")!,
    Deno.env.get("SUPABASE_ANON_KEY")!,
    {
      global: { headers: { Authorization: req.headers.get("Authorization") ?? "" } },
      auth: { persistSession: false },
    },
  );

  const { data: { user }, error: authError } = await supabase.auth.getUser();
  if (authError || !user) {
    return Response.json({ error: "Unauthorized" }, { status: 401, headers: corsHeaders });
  }

  const body = await req.json().catch(() => ({}));
  const channel = (body?.channel ?? body?.channelId ?? "").toString().trim();
  if (!channel) {
    return Response.json(
      { error: "Missing channel" },
      { status: 400, headers: corsHeaders },
    );
  }

  const uid = mapUserIdToAgoraUid(user.id);
  const expiresIn = 3600;
  const now = Math.floor(Date.now() / 1000);
  const token = RtcTokenBuilder.buildTokenWithUid(
    Deno.env.get("AGORA_APP_ID")!,
    Deno.env.get("AGORA_APP_CERT")!,
    channel,
    uid,
    RtcRole.PUBLISHER,
    now + expiresIn,
  );

  return Response.json(
    { token, uid, expiresIn, channel, appId: Deno.env.get("AGORA_APP_ID")! },
    { headers: corsHeaders },
  );
});
