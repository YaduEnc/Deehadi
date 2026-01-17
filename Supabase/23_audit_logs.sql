-- Create audit_logs table
create table public.audit_logs (
  id uuid default gen_random_uuid() primary key,
  entity_type text not null,
  entity_id uuid not null,
  action text not null,
  performed_by uuid references auth.users(id),
  created_at timestamptz default now()
);

-- Enable RLS
alter table public.audit_logs enable row level security;

-- Policy: Admins can view audit logs
create policy "Admins can view audit logs."
  on public.audit_logs for select
  using ( exists ( select 1 from public.admins where user_id = auth.uid() ) );
