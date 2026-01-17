-- Create car_media table
create table public.car_media (
  id uuid default gen_random_uuid() primary key,
  car_id uuid references public.cars(id) on delete cascade not null,
  media_type text check (media_type in ('image', 'video')),
  url text not null,
  position int default 0,
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.car_media enable row level security;

-- Policy: Public read access
create policy "Public can view car media."
  on public.car_media for select
  using ( true );

-- Policy: Owners can manage media for their cars
create policy "Owners can manage car media."
  on public.car_media for all
  using ( exists ( select 1 from public.cars where id = car_media.car_id and owner_id = auth.uid() ) );
