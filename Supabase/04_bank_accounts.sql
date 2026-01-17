-- Create bank_accounts table
create table public.bank_accounts (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  account_holder_name text not null,
  account_number text not null,
  ifsc text not null,
  bank_name text,
  is_primary boolean default false,
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.bank_accounts enable row level security;

-- Policy: Users can view their own bank accounts
create policy "Users can view own bank accounts."
  on public.bank_accounts for select
  using ( auth.uid() = user_id );

-- Policy: Users can insert their own bank accounts
create policy "Users can add bank accounts."
  on public.bank_accounts for insert
  with check ( auth.uid() = user_id );

-- Policy: Users can delete their own bank accounts
create policy "Users can delete own bank accounts."
  on public.bank_accounts for delete
  using ( auth.uid() = user_id );
