-- Create damages table
create table public.damages (
  id uuid default gen_random_uuid() primary key,
  booking_id uuid references public.bookings(id) on delete cascade not null,
  damage_type text check (damage_type in ('minor', 'major', 'total_loss')),
  description text,
  estimated_cost int,
  resolved_amount int,
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.damages enable row level security;

-- Policy: Users involved can view damages
create policy "Users involved can view damages."
  on public.damages for select
  using (
    exists (
      select 1 from public.bookings b
      join public.cars c on c.id = b.car_id
      where b.id = damages.booking_id
      and (b.renter_id = auth.uid() or c.owner_id = auth.uid())
    )
  );

-- Policy: Owners can report damages
create policy "Owners can report damages."
  on public.damages for insert
  with check (
    exists (
      select 1 from public.bookings b
      join public.cars c on c.id = b.car_id
      where b.id = damages.booking_id
      and c.owner_id = auth.uid()
    )
  );
