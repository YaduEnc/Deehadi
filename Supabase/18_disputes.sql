-- Create disputes table
create table public.disputes (
  id uuid default gen_random_uuid() primary key,
  booking_id uuid references public.bookings(id) on delete cascade not null,
  raised_by text check (raised_by in ('renter', 'owner')),
  reason text not null,
  status text default 'open' check (status in ('open', 'resolved', 'rejected')),
  resolved_by_admin_id uuid references auth.users(id),
  created_at timestamptz default now(),
  resolved_at timestamptz
);

-- Enable RLS
alter table public.disputes enable row level security;

-- Policy: Users involved can view disputes
create policy "Users involved can view disputes."
  on public.disputes for select
  using (
    exists (
      select 1 from public.bookings b
      join public.cars c on c.id = b.car_id
      where b.id = disputes.booking_id
      and (b.renter_id = auth.uid() or c.owner_id = auth.uid())
    )
  );

-- Policy: Users involved can raise disputes
create policy "Users involved can raise disputes."
  on public.disputes for insert
  with check (
    exists (
      select 1 from public.bookings b
      join public.cars c on c.id = b.car_id
      where b.id = disputes.booking_id
      and (b.renter_id = auth.uid() or c.owner_id = auth.uid())
    )
  );
