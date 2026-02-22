# Soma Operations Runbook

## 1) Sync appears stuck or repeatedly failing

1. Check app logs for sync lifecycle and failing step names.
2. Confirm user auth state is valid and network is available.
3. Verify offline queue contents and whether items are being dropped due to permanent schema errors.
4. Confirm Supabase table schemas still match app assumptions (`user_courses`, `user_learned_items`, `user_stats`).

Expected signals:
- Repeated `sync_retry_scheduled` analytics events.
- Sync error snackbar with failed step list.

## 2) FCM token not saved

1. Confirm notification permission is granted by the OS.
2. Check token registration logs and profile update path.
3. Verify `profiles.fcm_token` update policy/permissions in Supabase.
4. Use in-app fallback to open system notification settings and retry token registration.

Expected signals:
- `NotificationInitState.permissionDenied` or `NotificationInitState.tokenRegistrationFailed`.
- Logs around `_registerFcmToken` / `_upsertToken`.

## 3) Edge function returns 400/502 (AI features)

1. Validate payload contract (`text`, `target_language`) and length limits.
2. Confirm `OPENAI_API_KEY` is configured for edge runtime.
3. Inspect edge function logs for normalized error payload.
4. Retry from client (transient failures are retried with backoff in app layer).

Expected signals:
- Edge JSON errors with explicit contract message.
- Client retry logs for transient timeouts/network failures.
