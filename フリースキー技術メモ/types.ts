export type TrickType = 'air' | 'jib';
export type Stance = 'regular' | 'switch';
export type Takeoff = 'standard' | 'carving';

export interface TechLog {
  id: string;
  focus: string; // 意識
  outcome: string; // どう変わったか
  createdAt: number;
}

export interface Trick {
  id: string;
  type: TrickType;
  stance: Stance;
  takeoff?: Takeoff; // Only for Air usually
  axis?: string; // Cork, Bio, etc.
  spin: number;
  grab: string;
  customName?: string; // Optional override
  logs: TechLog[];
  updatedAt: number;
}

export const SPINS = [0, 180, 360, 540, 720, 900, 1080, 1260, 1440, 1620, 1800];
export const AXES = [
  '平軸',
  'コーク',
  'バイオ',
  'ミスティ',
  'ロデオ',
  'フラットスピン',
  'アンダーフリップ'
];

export const GRABS = [
  'なし',
  'セーフティ',
  'ミュート',
  'ジャパン',
  'テール',
  'ノーズ',
  'トラックドライバー',
  'オクトグラブ',
  'ステールフィッシュ',
  'クリティカル',
  'リードミュート',
  'リードジャパン',
  'リードテール',
  'ブラント',
  'スクリーミンシーマン',
  'タイパン'
];