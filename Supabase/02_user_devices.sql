-- Create user_devices table
create table public.user_devices (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  device_id text not null,
  device_type text,
  last_login_at timestamptz default now(),
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.user_devices enable row level security;

-- Policy: Users can view their own devices
create policy "Users can view own devices."
  on public.user_devices for select
  using ( auth.uid() = user_id );

-- Policy: Users can insert their own devices
create policy "Users can insert own devices."
  on public.user_devices for insert
  with check ( auth.uid() = user_id );
