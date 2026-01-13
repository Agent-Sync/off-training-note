import React, { useState, useMemo } from 'react';
import { Search, SlidersHorizontal, Plus, ArrowRight } from './components/Icons';
import { Trick, TrickType } from './types';
import { BottomSheet } from './components/BottomSheet';
import { NewTrickModal } from './components/NewTrickModal';
import { NewLogModal } from './components/NewLogModal';

// --- Helper to Generate Trick Name ---
const getTrickName = (trick: Omit<Trick, 'id' | 'logs' | 'updatedAt'>) => {
  const parts = [];
  
  // Stance
  if (trick.stance === 'switch') parts.push('スイッチ');
  // Regular is usually omitted, but can be added if specific context needed
  
  // Takeoff (Air only)
  if (trick.type === 'air' && trick.takeoff === 'carving') parts.push('カービング');
  
  // Axis (Air only)
  // Omit if it is the default "平軸" (Flat Axis)
  if (trick.type === 'air' && trick.axis && trick.axis !== '平軸') {
    parts.push(trick.axis);
  }
  
  // Spin
  if (trick.spin > 0) parts.push(trick.spin.toString());
  
  // Grab
  if (trick.grab && trick.grab !== 'なし') {
      parts.push(trick.grab);
  }
  
  // Fallback if empty (e.g. Regular Straight Air with no grab)
  if (parts.length === 0) return 'ストレートエア';

  return parts.join(' ');
};

// --- Mock Initial Data ---
const INITIAL_TRICKS: Trick[] = [
  {
    id: '1',
    type: 'air',
    stance: 'regular',
    takeoff: 'carving',
    axis: '平軸',
    spin: 540,
    grab: 'ミュート',
    logs: [
      { id: 'l1', focus: 'テイクオフで肩のラインを水平に保つ', outcome: '軸が安定して回転がスムーズになった', createdAt: Date.now() - 1000 * 60 * 60 * 24 * 2 },
      { id: 'l2', focus: '360の時点でランディングを見る', outcome: '着地が完璧に決まった', createdAt: Date.now() - 1000 * 60 * 60 * 24 * 5 }
    ],
    updatedAt: Date.now()
  },
  {
    id: '3',
    type: 'air',
    stance: 'regular',
    takeoff: 'standard',
    axis: 'コーク',
    spin: 720,
    grab: 'セーフティ',
    customName: 'コーク 720',
    logs: [
      { id: 'l_c7_1', focus: '右肩を下げながら抜ける', outcome: 'しっかり軸が入った', createdAt: Date.now() - 1000 * 60 * 60 * 24 * 1 }
    ],
    updatedAt: Date.now() - 1000 * 60 * 60 * 12
  },
  {
    id: '4',
    type: 'air',
    stance: 'switch',
    takeoff: 'standard',
    axis: '平軸',
    spin: 540,
    grab: 'ジャパン',
    logs: [
      { id: 'l_sw5_1', focus: '目線を先行させる', outcome: '回転不足が解消', createdAt: Date.now() - 1000 * 60 * 60 * 24 * 3 },
      { id: 'l_sw5_2', focus: 'グラブを長く持つ', outcome: '空中姿勢が安定した', createdAt: Date.now() - 1000 * 60 * 60 * 24 * 4 }
    ],
    updatedAt: Date.now() - 1000 * 60 * 60 * 24 * 3
  },
  {
    id: '5',
    type: 'air',
    stance: 'regular',
    takeoff: 'standard',
    axis: '平軸',
    spin: 360,
    grab: 'トラックドライバー',
    logs: [],
    updatedAt: Date.now() - 1000 * 60 * 60 * 24 * 6
  },
  {
    id: '6',
    type: 'air',
    stance: 'regular',
    takeoff: 'standard',
    axis: 'コーク',
    spin: 1080,
    grab: 'テール',
    customName: 'ダブルコーク 1080',
    logs: [
       { id: 'l_d10_1', focus: '1回転目をコンパクトに', outcome: '回転速度が上がった', createdAt: Date.now() - 1000 * 60 * 60 * 24 * 10 }
    ],
    updatedAt: Date.now() - 1000 * 60 * 60 * 24 * 10
  },
  {
    id: '2',
    type: 'jib',
    stance: 'switch',
    takeoff: 'standard',
    spin: 270,
    grab: 'なし',
    customName: 'スイッチ 270 イン',
    logs: [
      { id: 'l3', focus: 'リップで早めに弾く', outcome: 'ギャップを余裕で越えられた', createdAt: Date.now() - 1000 * 60 * 60 * 24 * 1 }
    ],
    updatedAt: Date.now()
  }
];

// --- Component: Header Tabs ---
const HeaderTabs: React.FC<{ activeTab: TrickType; onChange: (t: TrickType) => void }> = ({ activeTab, onChange }) => {
  const isAir = activeTab === 'air';
  
  return (
    <div className="sticky top-0 z-30 pt-3 pb-2 backdrop-blur-md bg-[#f3f4f6]/95 transition-all">
      <div className="flex justify-center w-full">
        <div className="relative flex">
            {/* Air Button */}
            <button
                onClick={() => onChange('air')}
                className={`w-24 py-2 text-lg font-bold uppercase tracking-wider transition-colors duration-300 ${
                    isAir ? 'text-black scale-105' : 'text-gray-400'
                }`}
            >
                エア
            </button>
            
            {/* Jib Button */}
            <button
                onClick={() => onChange('jib')}
                className={`w-24 py-2 text-lg font-bold uppercase tracking-wider transition-colors duration-300 ${
                    !isAir ? 'text-black scale-105' : 'text-gray-400'
                }`}
            >
                ジブ
            </button>

            {/* Sliding Indicator */}
            {/* 
                Button width = w-24 (6rem = 96px). 
                Indicator width = w-12 (3rem). 
                Center offset = (6rem - 3rem) / 2 = 1.5rem.
                Translate distance = 6rem (100% of button width).
            */}
            <div 
                className="absolute bottom-0 h-1 bg-black rounded-full transition-transform duration-300 ease-out shadow-sm"
                style={{
                    width: '3rem', // w-12
                    left: '1.5rem', // w-6 (center of first button)
                    transform: isAir ? 'translateX(0)' : 'translateX(6rem)' 
                }}
            />
        </div>
      </div>
    </div>
  );
};

// --- Component: Trick Card ---
const TrickCard: React.FC<{ trick: Trick; onClick: () => void }> = ({ trick, onClick }) => {
  const latestLog = trick.logs[0];
  const daysAgo = latestLog ? Math.floor((Date.now() - latestLog.createdAt) / (1000 * 60 * 60 * 24)) : 0;
  const name = trick.customName || getTrickName(trick);

  return (
    <div 
      onClick={onClick}
      className="bg-white rounded-2xl p-4 shadow-sm border border-gray-100 flex flex-col active:scale-[0.98] transition-transform w-full"
    >
      <div className="mb-3">
        <h3 className="font-bold text-gray-900 text-lg leading-tight">{name || '名称未設定'}</h3>
      </div>

      {latestLog ? (
        <div className="flex-1 flex flex-col">
          {/* Unified Gray Box Style (like Details) */}
          <div className="bg-gray-50/80 rounded-xl p-3 border border-gray-100">
             {/* Focus */}
             <div className="mb-2">
               <span className="block text-[10px] font-bold text-blue-600 uppercase tracking-wider mb-1">意識</span>
               <p className="text-gray-800 text-sm leading-relaxed">{latestLog.focus}</p>
             </div>
             
             {/* Divider */}
             <div className="flex items-center gap-2 my-2 opacity-40">
                <div className="h-[1px] flex-1 bg-gray-300"></div>
                <ArrowRight size={12} className="text-gray-400 rotate-90" />
                <div className="h-[1px] flex-1 bg-gray-300"></div>
             </div>

             {/* Outcome */}
             <div>
               <span className="block text-[10px] font-bold text-green-600 uppercase tracking-wider mb-1">どう変わったか</span>
               <p className="text-gray-800 text-sm leading-relaxed">{latestLog.outcome}</p>
             </div>
          </div>
          
          <div className="mt-2 flex justify-between items-center px-1">
            <span className="text-[10px] font-medium text-gray-400">{daysAgo === 0 ? '今日' : `${daysAgo}日前`}</span>
            <div className="text-[10px] text-gray-400 font-medium bg-gray-50/80 px-2 py-0.5 rounded-full border border-gray-100">
               {trick.logs.length} notes
            </div>
          </div>
        </div>
      ) : (
        <div className="flex-1 flex items-center justify-center border-2 border-dashed border-gray-100 rounded-xl mt-1 min-h-[80px] bg-gray-50/50">
            <span className="text-xs text-gray-400">メモなし</span>
        </div>
      )}
    </div>
  );
};

// --- Main App Component ---
export default function App() {
  const [tricks, setTricks] = useState<Trick[]>(INITIAL_TRICKS);
  const [activeTab, setActiveTab] = useState<TrickType>('air');
  const [searchQuery, setSearchQuery] = useState('');
  
  // Modal States
  const [selectedTrickId, setSelectedTrickId] = useState<string | null>(null);
  const [isNewTrickModalOpen, setIsNewTrickModalOpen] = useState(false);
  const [isNewLogModalOpen, setIsNewLogModalOpen] = useState(false);

  // Derived State
  const filteredTricks = useMemo(() => {
    return tricks
      .filter(t => t.type === activeTab)
      .filter(t => {
        const name = t.customName || getTrickName(t);
        return name.toLowerCase().includes(searchQuery.toLowerCase());
      })
      .sort((a, b) => b.updatedAt - a.updatedAt);
  }, [tricks, activeTab, searchQuery]);

  const selectedTrick = useMemo(() => 
    tricks.find(t => t.id === selectedTrickId), 
  [tricks, selectedTrickId]);

  // Handlers
  const handleAddTrick = (trickData: Omit<Trick, 'id' | 'logs' | 'updatedAt'>) => {
    const newTrick: Trick = {
      ...trickData,
      id: Date.now().toString(),
      logs: [],
      updatedAt: Date.now(),
    };
    setTricks(prev => [newTrick, ...prev]);
  };

  const handleAddLog = (focus: string, outcome: string) => {
    if (!selectedTrickId) return;

    setTricks(prev => prev.map(t => {
      if (t.id === selectedTrickId) {
        return {
          ...t,
          updatedAt: Date.now(),
          logs: [
            {
              id: Date.now().toString(),
              focus,
              outcome,
              createdAt: Date.now()
            },
            ...t.logs
          ]
        };
      }
      return t;
    }));
  };

  return (
    <div className="min-h-screen relative flex flex-col pb-24">
      {/* Header */}
      <HeaderTabs activeTab={activeTab} onChange={setActiveTab} />

      {/* Search & Filter */}
      <div className="px-4 py-4 flex gap-3 items-center sticky top-[60px] z-20 bg-transparent">
        <div className="absolute inset-0 bg-[#f3f4f6]/95 backdrop-blur-md -z-10" />
        <div className="relative flex-1 group">
          <div className="absolute inset-y-0 left-0 pl-3 flex items-center pointer-events-none">
            <Search className="h-5 w-5 text-gray-400 group-focus-within:text-blue-500 transition-colors" />
          </div>
          <input
            type="text"
            className="block w-full pl-10 pr-3 py-3 bg-white border-none rounded-2xl text-sm shadow-sm text-gray-900 placeholder-gray-400 focus:outline-none focus:ring-2 focus:ring-blue-100 transition-all"
            placeholder="トリックを検索..."
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
          />
        </div>
        <button className="p-3 bg-white rounded-2xl shadow-sm active:scale-95 transition-transform text-gray-600">
          <SlidersHorizontal className="h-5 w-5" />
        </button>
      </div>

      {/* Grid - Masonry Layout implementation */}
      <div className="flex-1 px-4 overflow-y-auto no-scrollbar z-10">
        {filteredTricks.length > 0 ? (
          <div className="flex gap-4 pb-8 items-start">
             {/* Left Column */}
             <div className="flex-1 flex flex-col gap-4">
               {filteredTricks.filter((_, i) => i % 2 === 0).map(trick => (
                 <TrickCard 
                   key={trick.id} 
                   trick={trick} 
                   onClick={() => setSelectedTrickId(trick.id)} 
                 />
               ))}
             </div>
             {/* Right Column */}
             <div className="flex-1 flex flex-col gap-4">
               {filteredTricks.filter((_, i) => i % 2 === 1).map(trick => (
                 <TrickCard 
                   key={trick.id} 
                   trick={trick} 
                   onClick={() => setSelectedTrickId(trick.id)} 
                 />
               ))}
             </div>
          </div>
        ) : (
          <div className="flex flex-col items-center justify-center h-64 text-gray-400/80">
             <div className="w-16 h-16 bg-white/50 backdrop-blur-sm rounded-full flex items-center justify-center mb-4 border border-gray-100">
               <Search className="h-6 w-6 opacity-30" />
             </div>
             <p>トリックが見つかりません</p>
             <p className="text-xs mt-1">+ を押して追加してください</p>
          </div>
        )}
      </div>

      {/* Floating Action Button */}
      <button
        onClick={() => setIsNewTrickModalOpen(true)}
        className="fixed bottom-6 right-6 bg-black text-white px-5 py-3 rounded-full font-bold shadow-xl shadow-black/20 flex items-center space-x-2 active:scale-90 transition-all hover:bg-gray-900 z-40"
      >
        <Plus className="h-5 w-5" />
        <span>新しいトリック</span>
      </button>

      {/* Modals */}
      <NewTrickModal 
        isOpen={isNewTrickModalOpen}
        onClose={() => setIsNewTrickModalOpen(false)}
        onAdd={handleAddTrick}
        currentType={activeTab}
      />

      {/* Detail Bottom Sheet */}
      <BottomSheet
        isOpen={!!selectedTrickId}
        onClose={() => setSelectedTrickId(null)}
        title={selectedTrick ? (selectedTrick.customName || getTrickName(selectedTrick)) : ''}
        footer={
          <button 
            onClick={() => setIsNewLogModalOpen(true)}
            className="w-full bg-black text-white font-bold py-3.5 rounded-xl shadow-lg shadow-black/10 active:scale-98 transition-transform flex justify-center items-center gap-2"
          >
            <Plus size={20} />
            <span>メモを追加</span>
          </button>
        }
      >
        {selectedTrick && (
          <div className="space-y-6">
            <div className="flex items-center gap-2 mb-4">
                <span className="px-2 py-1 bg-gray-100 rounded-md text-xs font-semibold text-gray-600 uppercase">
                    {selectedTrick.stance === 'regular' ? 'レギュラー' : 'スイッチ'}
                </span>
                {selectedTrick.takeoff && (
                    <span className="px-2 py-1 bg-gray-100 rounded-md text-xs font-semibold text-gray-600 uppercase">
                        {selectedTrick.takeoff === 'standard' ? 'ストレート' : 'カービング'}
                    </span>
                )}
                 {selectedTrick.axis && (
                    <span className="px-2 py-1 bg-gray-100 rounded-md text-xs font-semibold text-gray-600 uppercase">
                        {selectedTrick.axis}
                    </span>
                )}
            </div>

            {selectedTrick.logs.length === 0 ? (
                <div className="text-center py-10 text-gray-400 bg-gray-50 rounded-2xl border border-dashed border-gray-200">
                    <p>まだメモがありません</p>
                    <p className="text-sm mt-1">練習の意識を記録しましょう！</p>
                </div>
            ) : (
                <div className="relative border-l-2 border-gray-100 ml-3 space-y-8">
                {selectedTrick.logs.map((log) => (
                    <div key={log.id} className="relative pl-6">
                        {/* Timeline Dot */}
                        <div className="absolute -left-[9px] top-0 w-4 h-4 rounded-full border-4 border-white bg-blue-500 shadow-sm"></div>
                        
                        <div className="text-xs font-semibold text-gray-400 mb-2 uppercase tracking-wide">
                            {new Date(log.createdAt).toLocaleDateString()}
                        </div>

                        <div className="bg-gray-50 rounded-xl p-4 border border-gray-100">
                            {/* Focus Section */}
                            <div className="mb-3">
                                <div className="text-[10px] font-bold text-blue-600 uppercase tracking-wider mb-1">意識</div>
                                <p className="text-gray-800 text-sm leading-relaxed">{log.focus}</p>
                            </div>
                            
                            {/* Divider Arrow */}
                            <div className="flex items-center gap-2 my-2 opacity-50">
                                <div className="h-[1px] flex-1 bg-gray-200"></div>
                                <ArrowRight size={14} className="text-gray-400 rotate-90 sm:rotate-0" />
                                <div className="h-[1px] flex-1 bg-gray-200"></div>
                            </div>

                            {/* Outcome Section */}
                            <div>
                                <div className="text-[10px] font-bold text-green-600 uppercase tracking-wider mb-1">どう変わったか</div>
                                <p className="text-gray-800 text-sm leading-relaxed">{log.outcome}</p>
                            </div>
                        </div>
                    </div>
                ))}
                </div>
            )}
            
            {/* Spacer for FAB visibility in sheet */}
            <div className="h-12"></div>
          </div>
        )}
      </BottomSheet>

      {/* New Log Overlay (Inside Bottom Sheet context or global) */}
      <NewLogModal 
        isOpen={isNewLogModalOpen}
        onClose={() => setIsNewLogModalOpen(false)}
        onAdd={handleAddLog}
      />

    </div>
  );
}