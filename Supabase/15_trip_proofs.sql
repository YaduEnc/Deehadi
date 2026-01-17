-- Create trip_proofs table
create table public.trip_proofs (
  id uuid default gen_random_uuid() primary key,
  booking_id uuid references public.bookings(id) on delete cascade not null,
  proof_type text check (proof_type in ('pre_trip', 'post_trip')),
  fuel_level int,
  odometer_reading int,
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.trip_proofs enable row level security;

-- Policy: Users involved can view proofs
create policy "Users involved can view proofs."
  on public.trip_proofs for select
  using (
    exists (
      select 1 from public.bookings b
      join public.cars c on c.id = b.car_id
      where b.id = trip_proofs.booking_id
      and (b.renter_id = auth.uid() or c.owner_id = auth.uid())
    )
  );

-- Policy: Renters upload proofs
create policy "Renters can upload proofs."
  on public.trip_proofs for insert
  with check (
    exists (
      select 1 from public.bookings b
      where b.id = booking_id
      and b.renter_id = auth.uid()
    )
  );
