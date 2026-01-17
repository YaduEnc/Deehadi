-- Create trip_proof_media table
create table public.trip_proof_media (
  id uuid default gen_random_uuid() primary key,
  trip_proof_id uuid references public.trip_proofs(id) on delete cascade not null,
  media_type text check (media_type in ('image', 'video')),
  url text not null
);

-- Enable RLS
alter table public.trip_proof_media enable row level security;

-- Policy: Users involved can view proof media
create policy "Users involved can view proof media."
  on public.trip_proof_media for select
  using (
    exists (
      select 1 from public.trip_proofs tp
      join public.bookings b on b.id = tp.booking_id
      join public.cars c on c.id = b.car_id
      where tp.id = trip_proof_media.trip_proof_id
      and (b.renter_id = auth.uid() or c.owner_id = auth.uid())
    )
  );

-- Policy: Renters upload proof media
create policy "Renters can upload proof media."
  on public.trip_proof_media for insert
  with check (
    exists (
      select 1 from public.trip_proofs tp
      join public.bookings b on b.id = tp.booking_id
      where tp.id = trip_proof_id
      and b.renter_id = auth.uid()
    )
  );
