import React from 'react';
import { X } from './Icons';

interface BottomSheetProps {
  isOpen: boolean;
  onClose: () => void;
  title: string;
  children: React.ReactNode;
  footer?: React.ReactNode;
}

export const BottomSheet: React.FC<BottomSheetProps> = ({ isOpen, onClose, title, children, footer }) => {
  if (!isOpen) return null;

  return (
    <div className="fixed inset-0 z-50 flex flex-col justify-end">
      {/* Backdrop */}
      <div 
        className="absolute inset-0 bg-black/60 backdrop-blur-sm transition-opacity"
        onClick={onClose}
      />
      
      {/* Sheet Content */}
      <div className="relative w-full max-w-md mx-auto bg-white rounded-t-3xl shadow-2xl flex flex-col max-h-[90vh] animate-[slideUp_0.3s_ease-out]">
        <style>{`
          @keyframes slideUp {
            from { transform: translateY(100%); }
            to { transform: translateY(0); }
          }
        `}</style>
        
        {/* Drag Handle Area */}
        <div className="w-full flex justify-center pt-3 pb-2" onClick={onClose}>
            <div className="w-12 h-1.5 bg-gray-300 rounded-full" />
        </div>

        {/* Header */}
        <div className="px-6 py-2 flex items-center justify-between border-b border-gray-100">
          <h2 className="text-xl font-bold text-gray-800">{title}</h2>
          <button onClick={onClose} className="p-2 -mr-2 text-gray-400 hover:text-gray-600">
            <X size={24} />
          </button>
        </div>

        {/* Scrollable Body */}
        <div className="overflow-y-auto p-6 flex-1 no-scrollbar">
          {children}
        </div>

        {/* Footer (optional) */}
        {footer && (
          <div className="p-4 border-t border-gray-100 bg-white pb-8">
            {footer}
          </div>
        )}
      </div>
    </div>
  );
};