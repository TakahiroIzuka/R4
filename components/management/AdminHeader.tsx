'use client'

import { useState, useRef, useEffect } from 'react'
import { useRouter } from 'next/navigation'
import { createClient } from '@/lib/supabase/client'
import { SERVICE_CODES, ServiceCode } from '@/lib/constants/services'

const SERVICES = [
  { code: SERVICE_CODES.MEDICAL, name: 'メディカル', path: '/medical' },
  { code: SERVICE_CODES.HOUSE_BUILDER, name: '住宅会社', path: '/house-builder' },
  { code: SERVICE_CODES.VACATION_STAY, name: '宿泊施設', path: '/vacation-stay' },
]

interface AdminHeaderProps {
  visibleServiceCodes?: ServiceCode[]
}

export default function AdminHeader({ visibleServiceCodes }: AdminHeaderProps) {
  const router = useRouter()
  const [isMenuOpen, setIsMenuOpen] = useState(false)
  const [isModalOpen, setIsModalOpen] = useState(false)
  const menuRef = useRef<HTMLDivElement>(null)

  const handleLogout = async () => {
    const supabase = createClient()
    await supabase.auth.signOut()
    router.push('/auth/login')
  }

  const handleAccountClick = () => {
    setIsMenuOpen(false)
    // アカウントページへの遷移（将来的に実装）
    // router.push('/management/account')
  }

  const handleSiteNavigationClick = () => {
    setIsMenuOpen(false)
    setIsModalOpen(true)
  }

  const handleLogoutClick = () => {
    setIsMenuOpen(false)
    handleLogout()
  }

  // メニュー外クリックで閉じる
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (menuRef.current && !menuRef.current.contains(event.target as Node)) {
        setIsMenuOpen(false)
      }
    }

    if (isMenuOpen) {
      document.addEventListener('mousedown', handleClickOutside)
    }

    return () => {
      document.removeEventListener('mousedown', handleClickOutside)
    }
  }, [isMenuOpen])

  return (
    <>
      <header className="bg-white border-b border-gray-200 h-14 flex items-center justify-end px-6 shadow-sm">
        <div className="relative" ref={menuRef}>
          <button
            onClick={() => setIsMenuOpen(!isMenuOpen)}
            className="p-2 hover:bg-gray-100 rounded-full transition-colors"
            aria-label="メニューを開く"
          >
            <svg
              className="w-6 h-6 text-gray-600"
              fill="currentColor"
              viewBox="0 0 24 24"
            >
              <circle cx="5" cy="12" r="2" />
              <circle cx="12" cy="12" r="2" />
              <circle cx="19" cy="12" r="2" />
            </svg>
          </button>

          {isMenuOpen && (
            <div className="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg border border-gray-200 py-1 z-50">
              <button
                onClick={handleAccountClick}
                className="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
              >
                アカウント
              </button>
              <button
                onClick={handleSiteNavigationClick}
                className="w-full text-left px-4 py-2 text-sm text-gray-700 hover:bg-gray-100 transition-colors"
              >
                サイト遷移
              </button>
              <hr className="my-1 border-gray-200" />
              <button
                onClick={handleLogoutClick}
                className="w-full text-left px-4 py-2 text-sm text-red-600 hover:bg-gray-100 transition-colors"
              >
                ログアウト
              </button>
            </div>
          )}
        </div>
      </header>

      {/* サイト遷移モーダル */}
      {isModalOpen && (
        <div className="fixed inset-0 z-50 flex items-center justify-center">
          <div
            className="absolute inset-0 bg-black/50"
            onClick={() => setIsModalOpen(false)}
          />
          <div className="relative bg-white rounded-lg shadow-xl w-full max-w-md mx-4 p-6">
            <div className="flex items-center justify-between mb-4">
              <h2 className="text-lg font-semibold text-gray-900">サイト一覧</h2>
              <button
                onClick={() => setIsModalOpen(false)}
                className="p-1 hover:bg-gray-100 rounded-full transition-colors"
                aria-label="閉じる"
              >
                <svg
                  className="w-5 h-5 text-gray-500"
                  fill="none"
                  stroke="currentColor"
                  viewBox="0 0 24 24"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M6 18L18 6M6 6l12 12"
                  />
                </svg>
              </button>
            </div>
            <div className="space-y-2">
              {SERVICES
                .filter(service => !visibleServiceCodes || visibleServiceCodes.includes(service.code))
                .map((service) => (
                <a
                  key={service.code}
                  href={service.path}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="flex items-center justify-between w-full px-4 py-3 text-left text-gray-700 hover:bg-gray-50 rounded-lg border border-gray-200 transition-colors"
                >
                  <div className="flex items-center gap-3">
                    <span>{service.name}</span>
                    <span className="text-xs text-gray-400">{service.code}</span>
                  </div>
                  <svg
                    className="w-4 h-4 text-gray-400"
                    fill="none"
                    stroke="currentColor"
                    viewBox="0 0 24 24"
                  >
                    <path
                      strokeLinecap="round"
                      strokeLinejoin="round"
                      strokeWidth={2}
                      d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                    />
                  </svg>
                </a>
              ))}
              {visibleServiceCodes && visibleServiceCodes.length === 0 && (
                <p className="text-center text-gray-500 py-4">表示可能なサイトがありません</p>
              )}
            </div>
          </div>
        </div>
      )}
    </>
  )
}
