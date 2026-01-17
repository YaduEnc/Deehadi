-- Create kyc_records table
create table public.kyc_records (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users(id) on delete cascade not null,
  document_type text check (document_type in ('driving_license', 'aadhaar', 'pan')),
  document_number text,
  front_image_url text,
  back_image_url text,
  expiry_date date,
  status text default 'pending' check (status in ('pending', 'approved', 'rejected')),
  verified_by_admin_id uuid references auth.users(id),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Enable RLS
alter table public.kyc_records enable row level security;

-- Policy: Users can view their own KYC records
create policy "Users can view own KYC."
  on public.kyc_records for select
  using ( auth.uid() = user_id );

-- Policy: Users can insert their own KYC records
create policy "Users can submit KYC."
  on public.kyc_records for insert
  with check ( auth.uid() = user_id );

-- Policy: Admins (defined by role capability or specific list) can view all
-- NOTE: simplified for MVP, assuming public read for admins will be handled via App Logic or separate admin role check in future.
-- For now, purely based on user ownership.
