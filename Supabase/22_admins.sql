-- Create admins table
create table public.admins (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null unique,
  name text,
  role text,
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.admins enable row level security;

-- Policy: Only admins can view the admin table (circular dependency check handled by role usually, simpler for now)
-- For MVP: We assume direct DB access or specific manual insertion for admins.
create policy "Admins can view admins"
  on public.admins for select
  using ( exists ( select 1 from public.admins where user_id = auth.uid() ) );
