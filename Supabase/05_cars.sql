-- Create cars table
create table public.cars (
  id uuid default gen_random_uuid() primary key,
  owner_id uuid references auth.users(id) on delete cascade not null,
  registration_number text unique not null,
  brand text not null,
  model text not null,
  year int not null,
  fuel_type text not null,
  transmission text not null,
  seats int not null,
  city text not null,
  pickup_lat double precision,
  pickup_lng double precision,
  status text default 'active' check (status in ('active', 'inactive', 'suspended')),
  created_at timestamptz default now(),
  updated_at timestamptz default now(),
  deleted_at timestamptz
);

-- Enable RLS
alter table public.cars enable row level security;

-- Policy: Everyone can view active cars (for search)
create policy "Anyone can view active cars."
  on public.cars for select
  using ( status = 'active' and deleted_at is null );

-- Policy: Owners can view their own cars (even inactive)
create policy "Owners can view own cars."
  on public.cars for select
  using ( auth.uid() = owner_id );

-- Policy: Owners can insert their own cars
create policy "Owners can add cars."
  on public.cars for insert
  with check ( auth.uid() = owner_id );

-- Policy: Owners can update their own cars
create policy "Owners can update own cars."
  on public.cars for update
  using ( auth.uid() = owner_id );
