-- Add read_by column to chat_messages if it doesn't exist
alter table chat_messages 
add column if not exists read_by uuid[] default '{}';

-- Create RPC function to mark a message as read
create or replace function mark_chat_message_read(message_id uuid)
returns void
language plpgsql
security definer
as $$
begin
  update chat_messages
  set read_by = array_append(read_by, auth.uid())
  where id = message_id
  and not (read_by @> array[auth.uid()]);
end;
$$;
