-- Create ratings table
create table public.ratings (
  id uuid default gen_random_uuid() primary key,
  booking_id uuid references public.bookings(id) on delete cascade not null,
  rated_by uuid references auth.users(id) on delete cascade not null,
  rated_to uuid references auth.users(id) on delete cascade not null, -- User being rated (owner or renter)
  rating int check (rating >= 1 and rating <= 5),
  comment text,
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.ratings enable row level security;

-- Policy: Public read access (reviews are generally public)
create policy "Public can view ratings."
  on public.ratings for select
  using ( true );

-- Policy: Users involved in booking can create ratings
create policy "Users can rate bookings."
  on public.ratings for insert
  with check (
    exists (
      select 1 from public.bookings b
      join public.cars c on c.id = b.car_id
      where b.id = ratings.booking_id
      and (b.renter_id = auth.uid() or c.owner_id = auth.uid())
      and rated_by = auth.uid()
    )
  );
