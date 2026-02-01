-- Fix security warning: function_search_path_mutable
-- Sets explicit search_path for functions to prevent schema hijacking attacks

-- Fix build_air_trick_name function
alter function public.build_air_trick_name(text, text, text, integer, text, text) 
set search_path = 'pg_temp', 'pg_catalog';

-- Fix build_air_trick_name_en function  
alter function public.build_air_trick_name_en(text, text, text, integer, text, text)
set search_path = 'pg_temp', 'pg_catalog';

-- Fix set_trick_name trigger function
alter function public.set_trick_name()
set search_path = 'pg_temp', 'pg_catalog';

-- Fix set_memo_user_id trigger function
alter function public.set_memo_user_id()
set search_path = 'pg_temp', 'pg_catalog';
