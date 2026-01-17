-- Create challans table
create table public.challans (
  id uuid default gen_random_uuid() primary key,
  booking_id uuid references public.bookings(id) on delete cascade not null,
  challan_number text not null,
  amount int not null,
  status text default 'pending' check (status in ('pending', 'paid')),
  document_url text,
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.challans enable row level security;

-- Policy: Users involved can view challans
create policy "Users involved can view challans."
  on public.challans for select
  using (
    exists (
      select 1 from public.bookings b
      join public.cars c on c.id = b.car_id
      where b.id = challans.booking_id
      and (b.renter_id = auth.uid() or c.owner_id = auth.uid())
    )
  );

-- Policy: Owners can upload challans (since they receive them typically)
create policy "Owners can upload challans."
  on public.challans for insert
  with check (
    exists (
      select 1 from public.bookings b
      join public.cars c on c.id = b.car_id
      where b.id = challans.booking_id
      and c.owner_id = auth.uid()
    )
  );
