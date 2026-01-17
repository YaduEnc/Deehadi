-- Create car_availability table
create table public.car_availability (
  id uuid default gen_random_uuid() primary key,
  car_id uuid references public.cars(id) on delete cascade not null,
  start_date date not null,
  end_date date not null,
  is_available boolean default true
);

-- Enable RLS
alter table public.car_availability enable row level security;

-- Policy: Public read access
create policy "Public can view availability."
  on public.car_availability for select
  using ( true );

-- Policy: Owners can manage availability
create policy "Owners can manage availability."
  on public.car_availability for all
  using ( exists ( select 1 from public.cars where id = car_availability.car_id and owner_id = auth.uid() ) );
