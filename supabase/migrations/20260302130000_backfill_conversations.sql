-- Backfill conversations table based on existing messages
-- This script populates the new 'conversations' table from the existing 'messages' table.

DO $$
DECLARE
    r RECORD;
BEGIN
    -- We can populate the conversations table by grouping messages by sender/receiver pair.
    -- We need to do this twice: once for sender -> receiver, and once for receiver -> sender.
    -- This ensures both participants get a conversation entry.

    -- Insert/Update conversation for Sender (as owner) regarding Receiver (as other)
    INSERT INTO public.conversations (user_id, other_user_id, created_at, updated_at, last_message, last_message_at, unread_count)
    SELECT
        m.sender_id,
        m.receiver_id,
        MIN(m.created_at),
        MAX(m.created_at),
        (SELECT content FROM public.messages m2 WHERE m2.sender_id = m.sender_id AND m2.receiver_id = m.receiver_id ORDER BY m2.created_at DESC LIMIT 1),
        MAX(m.created_at),
        0 -- Sender has 0 unread from their own sent messages in this context (strictly speaking, unread count is about received messages)
        -- But wait, unread count is aggregating ALL messages between them.
        -- If I am the sender, I don't have unread messages from myself.
        -- I need to count messages FROM other TO me where is_read is false.
    FROM public.messages m
    GROUP BY m.sender_id, m.receiver_id
    ON CONFLICT (user_id, other_user_id) DO NOTHING;

    -- The above logic is slightly flawed because a conversation comprises messages in BOTH directions.
    -- We need to group by the pair {userA, userB} regardless of direction, and then project for each user.

    -- Better approach: iterate over all unique pairs.
    FOR r IN
        SELECT DISTINCT
            LEAST(sender_id, receiver_id) as u1,
            GREATEST(sender_id, receiver_id) as u2
        FROM public.messages
    LOOP
        -- For User 1 (u1) regarding User 2 (u2)
        INSERT INTO public.conversations (user_id, other_user_id, created_at, updated_at, last_message, last_message_at, unread_count)
        VALUES (
            r.u1,
            r.u2,
            (SELECT MIN(created_at) FROM public.messages WHERE (sender_id = r.u1 AND receiver_id = r.u2) OR (sender_id = r.u2 AND receiver_id = r.u1)),
            (SELECT MAX(created_at) FROM public.messages WHERE (sender_id = r.u1 AND receiver_id = r.u2) OR (sender_id = r.u2 AND receiver_id = r.u1)),
            (SELECT content FROM public.messages WHERE (sender_id = r.u1 AND receiver_id = r.u2) OR (sender_id = r.u2 AND receiver_id = r.u1) ORDER BY created_at DESC LIMIT 1),
            (SELECT MAX(created_at) FROM public.messages WHERE (sender_id = r.u1 AND receiver_id = r.u2) OR (sender_id = r.u2 AND receiver_id = r.u1)),
            (SELECT COUNT(*) FROM public.messages WHERE sender_id = r.u2 AND receiver_id = r.u1 AND is_read = false)
        )
        ON CONFLICT (user_id, other_user_id) DO UPDATE SET
            updated_at = EXCLUDED.updated_at,
            last_message = EXCLUDED.last_message,
            last_message_at = EXCLUDED.last_message_at,
            unread_count = EXCLUDED.unread_count;

        -- For User 2 (u2) regarding User 1 (u1)
        INSERT INTO public.conversations (user_id, other_user_id, created_at, updated_at, last_message, last_message_at, unread_count)
        VALUES (
            r.u2,
            r.u1,
            (SELECT MIN(created_at) FROM public.messages WHERE (sender_id = r.u1 AND receiver_id = r.u2) OR (sender_id = r.u2 AND receiver_id = r.u1)),
            (SELECT MAX(created_at) FROM public.messages WHERE (sender_id = r.u1 AND receiver_id = r.u2) OR (sender_id = r.u2 AND receiver_id = r.u1)),
            (SELECT content FROM public.messages WHERE (sender_id = r.u1 AND receiver_id = r.u2) OR (sender_id = r.u2 AND receiver_id = r.u1) ORDER BY created_at DESC LIMIT 1),
            (SELECT MAX(created_at) FROM public.messages WHERE (sender_id = r.u1 AND receiver_id = r.u2) OR (sender_id = r.u2 AND receiver_id = r.u1)),
            (SELECT COUNT(*) FROM public.messages WHERE sender_id = r.u1 AND receiver_id = r.u2 AND is_read = false)
        )
        ON CONFLICT (user_id, other_user_id) DO UPDATE SET
            updated_at = EXCLUDED.updated_at,
            last_message = EXCLUDED.last_message,
            last_message_at = EXCLUDED.last_message_at,
            unread_count = EXCLUDED.unread_count;

    END LOOP;
END $$;
