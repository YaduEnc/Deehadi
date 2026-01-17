-- Create insurance_policies table
create table public.insurance_policies (
  id uuid default gen_random_uuid() primary key,
  booking_id uuid references public.bookings(id) on delete cascade not null,
  provider_name text not null,
  policy_number text not null,
  policy_document_url text,
  coverage_start timestamptz not null,
  coverage_end timestamptz not null,
  status text default 'active' check (status in ('active', 'claimed', 'expired')),
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.insurance_policies enable row level security;

-- Policy: Users involved in the booking (renter & owner) can view the policy
create policy "Users involved can view policy."
  on public.insurance_policies for select
  using (
    exists (
      select 1 from public.bookings b
      join public.cars c on c.id = b.car_id
      where b.id = insurance_policies.booking_id
      and (b.renter_id = auth.uid() or c.owner_id = auth.uid())
    )
  );
