-- Exclude "none" values from search_text composition.
update public.memos m
set search_text = trim(both from concat_ws(
  ' ',
  t.custom_name,
  t.spin::text,
  nullif(t.grab, 'none'),
  case
    when t.grab = 'none' then null
    when t.grab = 'safety' then 'セーフティ'
    when t.grab = 'doubleSafety' then 'ダブルセーフティ'
    when t.grab = 'leadSafety' then 'リードセーフティ'
    when t.grab = 'mute' then 'ミュート'
    when t.grab = 'leadMute' then 'リードミュート'
    when t.grab = 'japan' then 'ジャパン'
    when t.grab = 'leadJapan' then 'リードジャパン'
    when t.grab = 'tail' then 'テール'
    when t.grab = 'leadTail' then 'リードテール'
    when t.grab = 'nose' then 'ノーズ'
    when t.grab = 'doubleNose' then 'ダブルノーズ'
    when t.grab = 'leadNose' then 'リードノーズ'
    when t.grab = 'truckDriver' then 'トラックドライバー'
    when t.grab = 'octoGrab' then 'オクトグラブ'
    when t.grab = 'leadOctoGrab' then 'リードオクトグラブ'
    when t.grab = 'staleFish' then 'ステールフィッシュ'
    when t.grab = 'leadStaleFish' then 'リードステールフィッシュ'
    when t.grab = 'critical' then 'クリティカル'
    when t.grab = 'leadCritical' then 'リードクリティカル'
    when t.grab = 'blunt' then 'ブラント'
    when t.grab = 'leadBlunt' then 'リードブラント'
    when t.grab = 'screaminSeamin' then 'スクリーミンシーミン'
    when t.grab = 'taipan' then 'タイパン'
    when t.grab = 'seatbelt' then 'シートベルト'
    when t.grab = 'leadTaipan' then 'リードタイパン'
    when t.grab = 'leadSeatbelt' then 'リードシートベルト'
    else null
  end,
  t.axis,
  case
    when t.axis = 'upright' then '平軸'
    when t.axis = 'backflip' then 'バックフリップ'
    when t.axis = 'frontflip' then 'フロントフリップ'
    when t.axis = 'cork' then 'コーク'
    when t.axis = 'bio' then 'バイオ'
    when t.axis = 'misty' then 'ミスティ'
    when t.axis = 'rodeo' then 'ロデオ'
    when t.axis = 'flatspin' then 'フラットスピン'
    when t.axis = 'underflip' then 'アンダーフリップ'
    when t.axis = 'doubleCork' then 'ダブルコーク'
    when t.axis = 'doubleMisty' then 'ダブルミスティ'
    when t.axis = 'doubleRodeo' then 'ダブルロデオ'
    else null
  end,
  t.stance,
  case
    when t.stance = 'regular' then 'レギュラー'
    when t.stance = 'switchStance' then 'スイッチ'
    else null
  end,
  t.takeoff,
  case
    when t.takeoff = 'straight' then 'ストレート'
    when t.takeoff = 'carving' then 'カービング'
    else null
  end,
  nullif(t.direction, 'none'),
  case
    when t.direction = 'left' then 'レフト'
    when t.direction = 'right' then 'ライト'
    else null
  end,
  case
    when t.stance = 'switchStance' and t.axis = 'upright' and t.spin = 0
      then 'ゼロ'
    else null
  end
))
from public.tricks t
where t.id = m.trick_id;

create or replace function public.set_memo_user_id_and_search_text()
returns trigger as $$
declare
  t_user_id uuid;
  t_custom_name text;
  t_spin integer;
  t_grab text;
  t_axis text;
  t_stance text;
  t_takeoff text;
  t_direction text;
begin
  select user_id, custom_name, spin, grab, axis, stance, takeoff, direction
    into t_user_id, t_custom_name, t_spin, t_grab, t_axis, t_stance, t_takeoff, t_direction
  from public.tricks
  where id = new.trick_id;

  if new.user_id is null then
    new.user_id = t_user_id;
  end if;

  new.search_text = trim(both from concat_ws(
    ' ',
    t_custom_name,
    t_spin::text,
    nullif(t_grab, 'none'),
    case
      when t_grab = 'none' then null
      when t_grab = 'safety' then 'セーフティ'
      when t_grab = 'doubleSafety' then 'ダブルセーフティ'
      when t_grab = 'leadSafety' then 'リードセーフティ'
      when t_grab = 'mute' then 'ミュート'
      when t_grab = 'leadMute' then 'リードミュート'
      when t_grab = 'japan' then 'ジャパン'
      when t_grab = 'leadJapan' then 'リードジャパン'
      when t_grab = 'tail' then 'テール'
      when t_grab = 'leadTail' then 'リードテール'
      when t_grab = 'nose' then 'ノーズ'
      when t_grab = 'doubleNose' then 'ダブルノーズ'
      when t_grab = 'leadNose' then 'リードノーズ'
      when t_grab = 'truckDriver' then 'トラックドライバー'
      when t_grab = 'octoGrab' then 'オクトグラブ'
      when t_grab = 'leadOctoGrab' then 'リードオクトグラブ'
      when t_grab = 'staleFish' then 'ステールフィッシュ'
      when t_grab = 'leadStaleFish' then 'リードステールフィッシュ'
      when t_grab = 'critical' then 'クリティカル'
      when t_grab = 'leadCritical' then 'リードクリティカル'
      when t_grab = 'blunt' then 'ブラント'
      when t_grab = 'leadBlunt' then 'リードブラント'
      when t_grab = 'screaminSeamin' then 'スクリーミンシーミン'
      when t_grab = 'taipan' then 'タイパン'
      when t_grab = 'seatbelt' then 'シートベルト'
      when t_grab = 'leadTaipan' then 'リードタイパン'
      when t_grab = 'leadSeatbelt' then 'リードシートベルト'
      else null
    end,
    t_axis,
    case
      when t_axis = 'upright' then '平軸'
      when t_axis = 'backflip' then 'バックフリップ'
      when t_axis = 'frontflip' then 'フロントフリップ'
      when t_axis = 'cork' then 'コーク'
      when t_axis = 'bio' then 'バイオ'
      when t_axis = 'misty' then 'ミスティ'
      when t_axis = 'rodeo' then 'ロデオ'
      when t_axis = 'flatspin' then 'フラットスピン'
      when t_axis = 'underflip' then 'アンダーフリップ'
      when t_axis = 'doubleCork' then 'ダブルコーク'
      when t_axis = 'doubleMisty' then 'ダブルミスティ'
      when t_axis = 'doubleRodeo' then 'ダブルロデオ'
      else null
    end,
    t_stance,
    case
      when t_stance = 'regular' then 'レギュラー'
      when t_stance = 'switchStance' then 'スイッチ'
      else null
    end,
    t_takeoff,
    case
      when t_takeoff = 'straight' then 'ストレート'
      when t_takeoff = 'carving' then 'カービング'
      else null
    end,
    nullif(t_direction, 'none'),
    case
      when t_direction = 'left' then 'レフト'
      when t_direction = 'right' then 'ライト'
      else null
    end,
    case
      when t_stance = 'switchStance' and t_axis = 'upright' and t_spin = 0
        then 'ゼロ'
      else null
    end
  ));
  return new;
end;
$$ language plpgsql;

create or replace function public.update_memo_search_text_from_trick()
returns trigger as $$
begin
  update public.memos
  set search_text = trim(both from concat_ws(
    ' ',
    new.custom_name,
    new.spin::text,
    nullif(new.grab, 'none'),
    case
      when new.grab = 'none' then null
      when new.grab = 'safety' then 'セーフティ'
      when new.grab = 'doubleSafety' then 'ダブルセーフティ'
      when new.grab = 'leadSafety' then 'リードセーフティ'
      when new.grab = 'mute' then 'ミュート'
      when new.grab = 'leadMute' then 'リードミュート'
      when new.grab = 'japan' then 'ジャパン'
      when new.grab = 'leadJapan' then 'リードジャパン'
      when new.grab = 'tail' then 'テール'
      when new.grab = 'leadTail' then 'リードテール'
      when new.grab = 'nose' then 'ノーズ'
      when new.grab = 'doubleNose' then 'ダブルノーズ'
      when new.grab = 'leadNose' then 'リードノーズ'
      when new.grab = 'truckDriver' then 'トラックドライバー'
      when new.grab = 'octoGrab' then 'オクトグラブ'
      when new.grab = 'leadOctoGrab' then 'リードオクトグラブ'
      when new.grab = 'staleFish' then 'ステールフィッシュ'
      when new.grab = 'leadStaleFish' then 'リードステールフィッシュ'
      when new.grab = 'critical' then 'クリティカル'
      when new.grab = 'leadCritical' then 'リードクリティカル'
      when new.grab = 'blunt' then 'ブラント'
      when new.grab = 'leadBlunt' then 'リードブラント'
      when new.grab = 'screaminSeamin' then 'スクリーミンシーミン'
      when new.grab = 'taipan' then 'タイパン'
      when new.grab = 'seatbelt' then 'シートベルト'
      when new.grab = 'leadTaipan' then 'リードタイパン'
      when new.grab = 'leadSeatbelt' then 'リードシートベルト'
      else null
    end,
    new.axis,
    case
      when new.axis = 'upright' then '平軸'
      when new.axis = 'backflip' then 'バックフリップ'
      when new.axis = 'frontflip' then 'フロントフリップ'
      when new.axis = 'cork' then 'コーク'
      when new.axis = 'bio' then 'バイオ'
      when new.axis = 'misty' then 'ミスティ'
      when new.axis = 'rodeo' then 'ロデオ'
      when new.axis = 'flatspin' then 'フラットスピン'
      when new.axis = 'underflip' then 'アンダーフリップ'
      when new.axis = 'doubleCork' then 'ダブルコーク'
      when new.axis = 'doubleMisty' then 'ダブルミスティ'
      when new.axis = 'doubleRodeo' then 'ダブルロデオ'
      else null
    end,
    new.stance,
    case
      when new.stance = 'regular' then 'レギュラー'
      when new.stance = 'switchStance' then 'スイッチ'
      else null
    end,
    new.takeoff,
    case
      when new.takeoff = 'straight' then 'ストレート'
      when new.takeoff = 'carving' then 'カービング'
      else null
    end,
    nullif(new.direction, 'none'),
    case
      when new.direction = 'left' then 'レフト'
      when new.direction = 'right' then 'ライト'
      else null
    end,
    case
      when new.stance = 'switchStance' and new.axis = 'upright' and new.spin = 0
        then 'ゼロ'
      else null
    end
  ))
  where trick_id = new.id;
  return new;
end;
$$ language plpgsql;
