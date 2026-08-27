begin;

alter table public.profiles
  add column ai_response_detail text not null default 'summary',
  add column show_legal_references boolean not null default true,
  add constraint profiles_ai_response_detail_check
    check (ai_response_detail in ('summary', 'detailed'));

commit;
