import React, { useState } from 'react';
import { X } from './Icons';
import { SPINS, GRABS, AXES, Trick, Stance, Takeoff, TrickType } from '../types';

interface NewTrickModalProps {
  isOpen: boolean;
  onClose: () => void;
  onAdd: (trick: Omit<Trick, 'id' | 'logs' | 'updatedAt'>) => void;
  currentType: TrickType;
}

export const NewTrickModal: React.FC<NewTrickModalProps> = ({ isOpen, onClose, onAdd, currentType }) => {
  const [stance, setStance] = useState<Stance>('regular');
  const [takeoff, setTakeoff] = useState<Takeoff>('standard');
  
  // Axis State - Default to empty
  const [axis, setAxis] = useState<string>('');
  const [showAxisSuggestions, setShowAxisSuggestions] = useState(false);

  // Spin State
  const [spin, setSpin] = useState<number>(0);
  const [showSpinSuggestions, setShowSpinSuggestions] = useState(false);

  // Grab State
  const [grab, setGrab] = useState<string>(''); 
  const [showGrabSuggestions, setShowGrabSuggestions] = useState(false);

  if (!isOpen) return null;

  const handleSubmit = () => {
    onAdd({
      type: currentType,
      stance,
      takeoff: currentType === 'air' ? takeoff : undefined,
      axis: currentType === 'air' ? (axis || undefined) : undefined,
      spin,
      grab: grab || 'なし',
    });
    onClose();
  };

  // Filter Logic
  const filteredAxes = AXES.filter(a => a.includes(axis));
  const filteredSpins = SPINS.filter(s => s.toString().includes(spin.toString()));
  const filteredGrabs = GRABS.filter(g => g.toLowerCase().includes(grab.toLowerCase()));

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center p-4">
      <div className="absolute inset-0 bg-black/50 backdrop-blur-sm" onClick={onClose} />
      
      <div className="relative bg-white rounded-2xl w-full max-w-sm overflow-hidden shadow-2xl animate-[fadeIn_0.2s_ease-out]">
         <style>{`
          @keyframes fadeIn {
            from { opacity: 0; transform: scale(0.95); }
            to { opacity: 1; transform: scale(1); }
          }
        `}</style>
        
        <div className="px-6 py-4 border-b border-gray-100 flex justify-between items-center">
          <h3 className="text-lg font-bold text-gray-800">新しい{currentType === 'air' ? 'エア' : 'ジブ'}トリック</h3>
          <button onClick={onClose} className="text-gray-400"><X size={20} /></button>
        </div>

        <div className="p-6 space-y-6">
          {/* Stance Selector */}
          <div className="space-y-2">
            <label className="text-xs font-semibold text-gray-500 uppercase tracking-wider">スタンス</label>
            <div className="grid grid-cols-2 gap-2 bg-gray-100 p-1 rounded-lg">
              <button 
                onClick={() => setStance('regular')}
                className={`py-2 text-sm font-bold rounded-md transition-all ${stance === 'regular' ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-500'}`}
              >
                レギュラー
              </button>
              <button 
                onClick={() => setStance('switch')}
                className={`py-2 text-sm font-bold rounded-md transition-all ${stance === 'switch' ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-500'}`}
              >
                スイッチ
              </button>
            </div>
          </div>

          {/* Takeoff & Axis Selector (Only for Air) */}
          {currentType === 'air' && (
            <>
              <div className="space-y-2">
                <label className="text-xs font-semibold text-gray-500 uppercase tracking-wider">テイクオフ</label>
                <div className="grid grid-cols-2 gap-2 bg-gray-100 p-1 rounded-lg">
                  <button 
                    onClick={() => setTakeoff('standard')}
                    className={`py-2 text-sm font-bold rounded-md transition-all ${takeoff === 'standard' ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-500'}`}
                  >
                    ストレート
                  </button>
                  <button 
                    onClick={() => setTakeoff('carving')}
                    className={`py-2 text-sm font-bold rounded-md transition-all ${takeoff === 'carving' ? 'bg-white text-blue-600 shadow-sm' : 'text-gray-500'}`}
                  >
                    カービング
                  </button>
                </div>
              </div>

              {/* Axis Selector (Custom UI) */}
              <div className="space-y-2">
                <label className="text-xs font-semibold text-gray-500 uppercase tracking-wider">軸</label>
                <div className="relative">
                  <input 
                    type="text"
                    value={axis}
                    onChange={(e) => {
                        setAxis(e.target.value);
                        setShowAxisSuggestions(true);
                    }}
                    onFocus={() => setShowAxisSuggestions(true)}
                    onBlur={() => setTimeout(() => setShowAxisSuggestions(false), 200)}
                    className="w-full appearance-none bg-gray-50 border border-gray-200 text-gray-700 font-bold py-3 px-4 pr-8 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent placeholder-gray-400"
                    placeholder="軸を選択"
                  />
                  <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                    <svg className="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/></svg>
                  </div>

                  {showAxisSuggestions && (
                      <div className="absolute z-30 w-full mt-2 bg-white border border-gray-100 rounded-xl shadow-xl max-h-48 overflow-y-auto no-scrollbar">
                          {filteredAxes.map((a) => (
                              <div
                                  key={a}
                                  className="px-4 py-3 hover:bg-gray-50 cursor-pointer text-sm font-bold text-gray-700 border-b border-gray-50 last:border-0 transition-colors"
                                  onMouseDown={() => {
                                      setAxis(a);
                                      setShowAxisSuggestions(false);
                                  }}
                              >
                                  {a}
                              </div>
                          ))}
                          {filteredAxes.length === 0 && (
                            <div className="px-4 py-3 text-gray-400 text-xs text-center">一致なし</div>
                          )}
                      </div>
                  )}
                </div>
              </div>
            </>
          )}

          {/* Spin Selector (Custom UI) */}
          <div className="space-y-2">
            <label className="text-xs font-semibold text-gray-500 uppercase tracking-wider">スピン</label>
            <div className="relative">
              <input 
                type="text" 
                inputMode="numeric"
                value={spin}
                onChange={(e) => {
                    const val = Number(e.target.value);
                    if (!isNaN(val)) {
                        setSpin(val);
                        setShowSpinSuggestions(true);
                    }
                }}
                onFocus={() => setShowSpinSuggestions(true)}
                onBlur={() => setTimeout(() => setShowSpinSuggestions(false), 200)}
                className="w-full appearance-none bg-gray-50 border border-gray-200 text-gray-700 font-bold py-3 px-4 pr-8 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent"
              />
              <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                <svg className="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/></svg>
              </div>

              {showSpinSuggestions && (
                  <div className="absolute z-20 w-full mt-2 bg-white border border-gray-100 rounded-xl shadow-xl max-h-48 overflow-y-auto no-scrollbar">
                      {filteredSpins.map((s) => (
                          <div
                              key={s}
                              className="px-4 py-3 hover:bg-gray-50 cursor-pointer text-sm font-bold text-gray-700 border-b border-gray-50 last:border-0 transition-colors"
                              onMouseDown={() => {
                                  setSpin(s);
                                  setShowSpinSuggestions(false);
                              }}
                          >
                              {s}
                          </div>
                      ))}
                      {filteredSpins.length === 0 && (
                        <div className="px-4 py-3 text-gray-400 text-xs text-center">一致なし</div>
                      )}
                  </div>
              )}
            </div>
          </div>

          {/* Grab Selector (Custom UI) */}
          <div className="space-y-2">
            <label className="text-xs font-semibold text-gray-500 uppercase tracking-wider">グラブ</label>
            <div className="relative">
              <input 
                type="text"
                value={grab}
                onChange={(e) => {
                    setGrab(e.target.value);
                    setShowGrabSuggestions(true);
                }}
                onFocus={() => setShowGrabSuggestions(true)}
                onBlur={() => setTimeout(() => setShowGrabSuggestions(false), 200)}
                placeholder="グラブを選択"
                className="w-full appearance-none bg-gray-50 border border-gray-200 text-gray-700 font-bold py-3 px-4 pr-8 rounded-xl focus:outline-none focus:ring-2 focus:ring-blue-500 focus:border-transparent placeholder-gray-400"
              />
              <div className="pointer-events-none absolute inset-y-0 right-0 flex items-center px-2 text-gray-700">
                <svg className="fill-current h-4 w-4" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20"><path d="M9.293 12.95l.707.707L15.657 8l-1.414-1.414L10 10.828 5.757 6.586 4.343 8z"/></svg>
              </div>
              
              {showGrabSuggestions && (
                  <div className="absolute z-10 w-full mt-2 bg-white border border-gray-100 rounded-xl shadow-xl max-h-48 overflow-y-auto no-scrollbar">
                      {filteredGrabs.map((g) => (
                          <div
                              key={g}
                              className="px-4 py-3 hover:bg-gray-50 cursor-pointer text-sm font-bold text-gray-700 border-b border-gray-50 last:border-0 transition-colors"
                              onMouseDown={() => {
                                  setGrab(g);
                                  setShowGrabSuggestions(false);
                              }}
                          >
                              {g}
                          </div>
                      ))}
                      {filteredGrabs.length === 0 && (
                          <div className="px-4 py-3 text-gray-400 text-xs text-center">
                              一致するグラブがありません
                          </div>
                      )}
                  </div>
              )}
            </div>
          </div>
        </div>

        <div className="px-6 py-4 bg-gray-50 border-t border-gray-100 flex justify-end space-x-3">
            <button onClick={onClose} className="px-4 py-2 text-gray-600 font-bold">キャンセル</button>
            <button onClick={handleSubmit} className="px-6 py-2 bg-blue-600 text-white rounded-lg font-bold shadow-lg shadow-blue-600/30 active:scale-95 transition-transform">
                作成する
            </button>
        </div>
      </div>
    </div>
  );
};