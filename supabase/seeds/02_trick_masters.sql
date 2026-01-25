insert into public.grabs (code, label_ja, label_en, sort_order) values
('none', 'なし', 'None', 0),
('safety', 'セーフティ', 'Safety', 1),
('doubleSafety', 'ダブルセーフティ', 'Double Safety', 2),
('mute', 'ミュート', 'Mute', 3),
('japan', 'ジャパン', 'Japan', 4),
('tail', 'テール', 'Tail', 5),
('nose', 'ノーズ', 'Nose', 6),
('doubleNose', 'ダブルノーズ', 'Double Nose', 7),
('truckDriver', 'トラックドライバー', 'Truck Driver', 8),
('octoGrab', 'オクトグラブ', 'Octo Grab', 9),
('staleFish', 'ステールフィッシュ', 'Stale Fish', 10),
('critical', 'クリティカル', 'Critical', 11),
('blunt', 'ブラント', 'Blunt', 12),
('screaminSeamin', 'スクリーミンシーミン', 'Screamin Seamin', 13),
('taipan', 'タイパン', 'Taipan', 14),
('seatbelt', 'シートベルト', 'Seatbelt', 15),
('leadSafety', 'リードセーフティ', 'Lead Safety', 16),
('leadMute', 'リードミュート', 'Lead Mute', 17),
('leadJapan', 'リードジャパン', 'Lead Japan', 18),
('leadTail', 'リードテール', 'Lead Tail', 19),
('leadNose', 'リードノーズ', 'Lead Nose', 20),
('leadOctoGrab', 'リードオクトグラブ', 'Lead Octo Grab', 21),
('leadStaleFish', 'リードステールフィッシュ', 'Lead Stale Fish', 22),
('leadCritical', 'リードクリティカル', 'Lead Critical', 23),
('leadBlunt', 'リードブラント', 'Lead Blunt', 24),
('leadTaipan', 'リードタイパン', 'Lead Taipan', 25),
('leadSeatbelt', 'リードシートベルト', 'Lead Seatbelt', 26)
on conflict (code) do nothing;

insert into public.axes (code, label_ja, label_en, sort_order) values
('upright', '平軸', 'Upright', 0),
('backflip', 'バックフリップ', 'Backflip', 1),
('frontflip', 'フロントフリップ', 'Frontflip', 2),
('cork', 'コーク', 'Cork', 3),
('bio', 'バイオ', 'Bio', 4),
('misty', 'ミスティ', 'Misty', 5),
('rodeo', 'ロデオ', 'Rodeo', 6),
('flatspin', 'フラットスピン', 'Flatspin', 7),
('underflip', 'アンダーフリップ', 'Underflip', 8),
('doubleCork', 'ダブルコーク', 'Double Cork', 9),
('doubleMisty', 'ダブルミスティ', 'Double Misty', 10),
('doubleRodeo', 'ダブルロデオ', 'Double Rodeo', 11)
on conflict (code) do nothing;

insert into public.spins (value, label_ja, label_en, sort_order) values
(0, '0', '0', 0),
(180, '180', '180', 1),
(360, '360', '360', 2),
(540, '540', '540', 3),
(720, '720', '720', 4),
(900, '900', '900', 5),
(1080, '1080', '1080', 6),
(1260, '1260', '1260', 7),
(1440, '1440', '1440', 8),
(1620, '1620', '1620', 9),
(1800, '1800', '1800', 10)
on conflict (value) do nothing;
