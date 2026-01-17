-- Create payouts table
create table public.payouts (
  id uuid default gen_random_uuid() primary key,
  booking_id uuid references public.bookings(id) on delete cascade not null,
  owner_id uuid references auth.users(id) on delete cascade not null,
  amount int not null,
  status text default 'pending' check (status in ('pending', 'released', 'held')),
  released_at timestamptz
);

-- Enable RLS
alter table public.payouts enable row level security;

-- Policy: Owners can view their own payouts
create policy "Owners can view own payouts."
  on public.payouts for select
  using ( auth.uid() = owner_id );
