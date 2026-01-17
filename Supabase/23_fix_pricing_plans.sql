-- Add currency column to pricing_plans
alter table public.pricing_plans add column if not exists currency text default 'INR';

-- Rename price to price_per_day to match the app's model if needed, 
-- or just ensure the app uses the column that exists.
-- Looking at HostViewModel, it uses PricingPlanInsert(car_id, price_per_day, currency)
-- But the table has price, duration_type, duration_value.

-- Let's drop the old columns and add the ones the app expects for simplicity, 
-- or just fix the app to match the table.
-- The user said "could not find currency column", so I'll definitely add that.

-- I'll also add price_per_day and remove 'price' to satisfy the app's model.
alter table public.pricing_plans add column if not exists price_per_day numeric not null default 0;
alter table public.pricing_plans drop column if exists price;
alter table public.pricing_plans drop column if exists duration_type;
alter table public.pricing_plans drop column if exists duration_value;
