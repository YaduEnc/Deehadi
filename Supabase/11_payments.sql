-- Create payments table
create table public.payments (
  id uuid default gen_random_uuid() primary key,
  booking_id uuid references public.bookings(id) on delete cascade not null,
  user_id uuid references auth.users(id) on delete set null,
  amount int not null,
  type text check (type in ('rental', 'deposit', 'penalty', 'refund')),
  status text default 'initiated' check (status in ('initiated', 'success', 'failed')),
  payment_gateway_ref text,
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.payments enable row level security;

-- Policy: Users can view their own payments
create policy "Users can view own payments."
  on public.payments for select
  using ( auth.uid() = user_id );

-- Policy: System/Admin should insert payments typically, but for MVP we might allow authenticated users to initiate.
create policy "Users can initiate payments."
  on public.payments for insert
  with check ( auth.uid() = user_id );
