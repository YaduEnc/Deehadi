-- Create bookings table
create table public.bookings (
  id uuid default gen_random_uuid() primary key,
  car_id uuid references public.cars(id) on delete restrict not null,
  renter_id uuid references auth.users(id) on delete cascade not null,
  start_time timestamptz not null,
  end_time timestamptz not null,
  status text default 'pending' check (status in ('pending', 'active', 'completed', 'cancelled', 'disputed')),
  total_amount int not null,
  security_deposit int not null,
  late_fee int default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Enable RLS
alter table public.bookings enable row level security;

-- Policy: Renters can view their own bookings
create policy "Renters can view own bookings."
  on public.bookings for select
  using ( auth.uid() = renter_id );

-- Policy: Owners can view bookings for their cars, but we need a join or check.
-- Efficient check: user is owner of the referenced car.
create policy "Owners can view bookings for their cars."
  on public.bookings for select
  using ( exists ( select 1 from public.cars where id = bookings.car_id and owner_id = auth.uid() ) );

-- Policy: Renters can create bookings
create policy "Renters can create bookings."
  on public.bookings for insert
  with check ( auth.uid() = renter_id );

-- Policy: Owners can update bookings (e.g. approve/reject if manual, or system updates)
create policy "Owners can update car bookings."
  on public.bookings for update
  using ( exists ( select 1 from public.cars where id = bookings.car_id and owner_id = auth.uid() ) );
