import React, { useState } from 'react';
import { ArrowRight } from './Icons';

interface NewLogModalProps {
  isOpen: boolean;
  onClose: () => void;
  onAdd: (focus: string, outcome: string) => void;
}

export const NewLogModal: React.FC<NewLogModalProps> = ({ isOpen, onClose, onAdd }) => {
  const [focus, setFocus] = useState('');
  const [outcome, setOutcome] = useState('');

  if (!isOpen) return null;

  const handleSubmit = () => {
    if (focus.trim() && outcome.trim()) {
      onAdd(focus, outcome);
      setFocus('');
      setOutcome('');
      onClose();
    }
  };

  return (
    <div className="fixed inset-0 z-[60] flex items-end sm:items-center justify-center">
      <div className="absolute inset-0 bg-black/60 backdrop-blur-sm" onClick={onClose} />
      
      <div className="relative bg-white w-full max-w-md rounded-t-3xl sm:rounded-2xl shadow-2xl p-6 animate-[slideUp_0.3s_ease-out] sm:animate-[fadeIn_0.2s_ease-out]">
        <h3 className="text-xl font-bold text-gray-800 mb-6">新しい技術メモ</h3>
        
        <div className="space-y-6">
            <div className="space-y-2">
                <label className="text-sm font-semibold text-gray-500">意識 (Focus)</label>
                <textarea 
                    value={focus}
                    onChange={(e) => setFocus(e.target.value)}
                    placeholder="例: 早めにランディングを見る、肩を水平に..."
                    className="w-full bg-gray-50 border border-gray-200 rounded-xl p-3 focus:ring-2 focus:ring-blue-500 focus:outline-none min-h-[80px]"
                />
            </div>

            <div className="flex justify-center text-gray-400">
                <ArrowRight className="transform rotate-90" />
            </div>

            <div className="space-y-2">
                <label className="text-sm font-semibold text-gray-500">どう変わったか (Result)</label>
                <textarea 
                    value={outcome}
                    onChange={(e) => setOutcome(e.target.value)}
                    placeholder="例: 回転がスムーズになった、着地が決まった..."
                    className="w-full bg-gray-50 border border-gray-200 rounded-xl p-3 focus:ring-2 focus:ring-blue-500 focus:outline-none min-h-[80px]"
                />
            </div>
        </div>

        <div className="mt-8 grid grid-cols-2 gap-4">
            <button 
                onClick={onClose}
                className="w-full py-3 rounded-xl border border-gray-200 text-gray-600 font-bold"
            >
                キャンセル
            </button>
            <button 
                onClick={handleSubmit}
                disabled={!focus.trim() || !outcome.trim()}
                className="w-full py-3 rounded-xl bg-black text-white font-bold shadow-lg disabled:opacity-50 disabled:shadow-none active:scale-95 transition-all"
            >
                追加する
            </button>
        </div>
      </div>
    </div>
  );
};