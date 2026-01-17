-- Create insurance_claims table
create table public.insurance_claims (
  id uuid default gen_random_uuid() primary key,
  insurance_policy_id uuid references public.insurance_policies(id) on delete cascade not null,
  claim_reason text not null,
  claim_amount int,
  status text default 'initiated' check (status in ('initiated', 'approved', 'rejected', 'paid')),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Enable RLS
alter table public.insurance_claims enable row level security;

-- Policy: Users involved in the policy (via booking) can view claims
create policy "Users involved can view claims."
  on public.insurance_claims for select
  using (
    exists (
      select 1 from public.insurance_policies ip
      join public.bookings b on b.id = ip.booking_id
      join public.cars c on c.id = b.car_id
      where ip.id = insurance_claims.insurance_policy_id
      and (b.renter_id = auth.uid() or c.owner_id = auth.uid())
    )
  );
