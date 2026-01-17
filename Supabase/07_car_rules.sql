-- Create car_rules table
create table public.car_rules (
  id uuid default gen_random_uuid() primary key,
  car_id uuid references public.cars(id) on delete cascade not null,
  no_smoking boolean default true,
  city_limit_km int default 200,
  allowed_outstation boolean default false,
  cleaning_fee int default 500,
  smoking_penalty int default 2000,
  late_fee_per_hour int default 500
);

-- Enable RLS
alter table public.car_rules enable row level security;

-- Policy: Public read access
create policy "Public can view car rules."
  on public.car_rules for select
  using ( true );

-- Policy: Owners can manage rules
create policy "Owners can manage car rules."
  on public.car_rules for all
  using ( exists ( select 1 from public.cars where id = car_rules.car_id and owner_id = auth.uid() ) );
