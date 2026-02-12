-- Create a new public bucket for chat assets
insert into storage.buckets (id, name, public)
values ('chat_assets', 'chat_assets', true)
on conflict (id) do nothing;

-- Policy: Give authenticated users access to upload files
create policy "Authenticated users can upload chat assets"
on storage.objects for insert
to authenticated
with check ( bucket_id = 'chat_assets' );

-- Policy: Give public access to read files
create policy "Public can read chat assets"
on storage.objects for select
to public
using ( bucket_id = 'chat_assets' );

-- Policy: Users can delete their own files (optional, but good for cleanup)
create policy "Users can delete their own chat assets"
on storage.objects for delete
to authenticated
using ( bucket_id = 'chat_assets' and auth.uid() = owner );
