-- Create pricing_plans table
create table public.pricing_plans (
  id uuid default gen_random_uuid() primary key,
  car_id uuid references public.cars(id) on delete cascade not null,
  duration_type text check (duration_type in ('day', 'week')),
  duration_value int not null,
  price int not null,
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.pricing_plans enable row level security;

-- Policy: Public read access
create policy "Public can view pricing."
  on public.pricing_plans for select
  using ( true );

-- Policy: Owners can manage pricing
create policy "Owners can manage pricing."
  on public.pricing_plans for all
  using ( exists ( select 1 from public.cars where id = pricing_plans.car_id and owner_id = auth.uid() ) );
