import { createClient } from 'jsr:@supabase/supabase-js@2';
import { create, getNumericDate } from 'https://deno.land/x/djwt@v3.0.1/mod.ts';

const corsHeaders = {
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
};

async function getAccessToken(clientEmail: string, privateKey: string) {
    const HEADER = { alg: 'RS256', typ: 'JWT' };
    const SCOPES = 'https://www.googleapis.com/auth/firebase.messaging';

    const payload = {
        iss: clientEmail,
        sub: clientEmail,
        aud: 'https://oauth2.googleapis.com/token',
        iat: getNumericDate(0),
        exp: getNumericDate(3600),
        scope: SCOPES,
    };

    // Convert PEM private key to CryptoKey
    const pemHeader = "-----BEGIN PRIVATE KEY-----";
    const pemFooter = "-----END PRIVATE KEY-----";
    const pemContents = privateKey.substring(
        privateKey.indexOf(pemHeader) + pemHeader.length,
        privateKey.indexOf(pemFooter)
    ).replace(/\s/g, "");

    const binaryDer = Uint8Array.from(atob(pemContents), (c) => c.charCodeAt(0));
    const key = await crypto.subtle.importKey(
        "pkcs8",
        binaryDer,
        { name: "RSASSA-PKCS1-v1_5", hash: "SHA-256" },
        false,
        ["sign"]
    );

    const jwt = await create(HEADER, payload, key);

    const res = await fetch('https://oauth2.googleapis.com/token', {
        method: 'POST',
        headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
        body: new URLSearchParams({
            grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
            assertion: jwt,
        }),
    });

    const data = await res.json();
    return data.access_token;
}

Deno.serve(async (req: Request) => {
    if (req.method === 'OPTIONS') {
        return new Response('ok', { headers: corsHeaders });
    }

    try {
        const payload = await req.json();
        const toUserId = payload.toUserId;
        const callerName = payload.callerName;
        const callerId = payload.callerId;
        const circleId = payload.circleId;

        if (!toUserId || !callerName) {
            return new Response(JSON.stringify({ error: 'Missing required fields' }), {
                status: 400,
                headers: { ...corsHeaders, 'Content-Type': 'application/json' }
            });
        }

        const supabaseUrl = Deno.env.get('SUPABASE_URL')!;
        const supabaseKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!;

        // New FCM v1 Secrets
        const firebaseProjectId = Deno.env.get('FIREBASE_PROJECT_ID');
        const firebaseClientEmail = Deno.env.get('FIREBASE_CLIENT_EMAIL');
        const firebasePrivateKey = Deno.env.get('FIREBASE_PRIVATE_KEY');

        if (!firebaseProjectId || !firebaseClientEmail || !firebasePrivateKey) {
            console.warn('send-call-push: Firebase secrets not set');
            return new Response(JSON.stringify({ warning: 'Firebase credentials not configured' }), {
                status: 200,
                headers: { ...corsHeaders, 'Content-Type': 'application/json' }
            });
        }

        const supabase = createClient(supabaseUrl, supabaseKey);
        const { data: profile } = await supabase
            .from('profiles')
            .select('fcm_token')
            .eq('id', toUserId)
            .maybeSingle();

        const fcmToken = profile?.fcm_token;
        if (!fcmToken) {
            return new Response(JSON.stringify({ warning: 'no token' }), {
                status: 200,
                headers: { ...corsHeaders, 'Content-Type': 'application/json' }
            });
        }

        // Get OAuth2 token for FCM v1
        const accessToken = await getAccessToken(firebaseClientEmail, firebasePrivateKey);

        // Send high priority data-only push via FCM v1
        const fcmRes = await fetch(`https://fcm.googleapis.com/v1/projects/${firebaseProjectId}/messages:send`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Authorization': `Bearer ${accessToken}`,
            },
            body: JSON.stringify({
                message: {
                    token: fcmToken,
                    data: {
                        push_type: 'call',
                        caller_id: callerId || '',
                        caller_name: callerName || 'Someone',
                        circle_id: circleId || '',
                    },
                    android: {
                        priority: 'high',
                    },
                    apns: {
                        payload: {
                            aps: {
                                content_available: true,
                            },
                        },
                        headers: {
                            'apns-priority': '10',
                            'apns-push-type': 'background',
                        },
                    },
                },
            }),
        });

        const fcmBody = await fcmRes.json();
        console.log(`send-call-push FCM v1 response ${fcmRes.status}`, fcmBody);

        return new Response(JSON.stringify({ success: true, status: fcmRes.status }), {
            status: 200,
            headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        });
    } catch (err) {
        console.error('send-call-push error:', err);
        return new Response(JSON.stringify({ error: err.message }), {
            status: 500,
            headers: { ...corsHeaders, 'Content-Type': 'application/json' }
        });
    }
});
