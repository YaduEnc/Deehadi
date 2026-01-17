-- Create a table for public profiles using Supabase patterns
create table public.user_profiles (
  id uuid not null references auth.users(id) on delete cascade primary key,
  full_name text,
  dob date,
  profile_photo_url text,
  address text,
  city text,
  state text,
  pincode text,
  phone_number text,
  is_owner boolean default false,
  onboarding_completed boolean default false,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Enable RLS
alter table public.user_profiles enable row level security;

-- Policy: Public profiles are viewable by everyone
create policy "Public profiles are viewable by everyone."
  on public.user_profiles for select
  using ( true );

-- Policy: Users can insert their own profile
create policy "Users can insert their own profile."
  on public.user_profiles for insert
  with check ( auth.uid() = id );

-- Policy: Users can update their own profile
create policy "Users can update own profile."
  on public.user_profiles for update
  using ( auth.uid() = id );

-- Function to handle new user signup
create or replace function public.handle_new_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.user_profiles (id, full_name, onboarding_completed)
  values (new.id, new.raw_user_meta_data ->> 'full_name', false);
  return new;
end;
$$;

-- Trigger to call the function on signup
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();
