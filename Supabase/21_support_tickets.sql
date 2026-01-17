-- Create support_tickets table
create table public.support_tickets (
  id uuid default gen_random_uuid() primary key,
  booking_id uuid references public.bookings(id) on delete set null,
  user_id uuid references auth.users(id) on delete cascade not null,
  category text check (category in ('accident', 'payment', 'damage', 'other')),
  message text not null,
  status text default 'open' check (status in ('open', 'in_progress', 'closed')),
  created_at timestamptz default now(),
  closed_at timestamptz
);

-- Enable RLS
alter table public.support_tickets enable row level security;

-- Policy: Users can view their own tickets
create policy "Users can view own tickets."
  on public.support_tickets for select
  using ( auth.uid() = user_id );

-- Policy: Users can create tickets
create policy "Users can create tickets."
  on public.support_tickets for insert
  with check ( auth.uid() = user_id );
