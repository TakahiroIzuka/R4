'use client'

import Link from 'next/link'
import { usePathname } from 'next/navigation'
import { useState } from 'react'

interface AdminSidebarProps {
  currentUserType: 'admin' | 'user'
  basePath?: '/management' | '/admin-management'
}

const getMenuItems = (userType: 'admin' | 'user', basePath: string) => {
  // user用は「施設一覧」「クチコミ一覧」のみ
  if (userType === 'user') {
    return [
      {
        label: '施設一覧',
        href: `${basePath}/facilities`,
      },
      {
        label: 'クチコミ一覧',
        href: `${basePath}/reviews`,
      },
    ]
  }

  // admin用のメニュー
  return [
    {
      label: '会社一覧',
      href: `${basePath}/companies`,
    },
    {
      label: 'ユーザー一覧',
      href: `${basePath}/users`,
    },
    {
      label: '施設一覧',
      href: `${basePath}/facilities`,
    },
    {
      label: 'クチコミ一覧',
      href: `${basePath}/reviews`,
    },
    {
      label: 'ギフトコード一覧',
      href: basePath,
    },
  ]
}

const getMasterItems = (basePath: string) => [
  {
    label: 'サービス',
    href: `${basePath}/masters/services`,
  },
  {
    label: 'ジャンル',
    href: `${basePath}/masters/genres`,
  },
  {
    label: '都道府県・地域',
    href: `${basePath}/masters/regions`,
  },
  {
    label: 'ギフトコード額',
    href: `${basePath}/masters/gift-code-amounts`,
  },
]

export default function AdminSidebar({ currentUserType, basePath = '/management' }: AdminSidebarProps) {
  const pathname = usePathname()
  const [isMasterExpanded, setIsMasterExpanded] = useState(pathname.startsWith(`${basePath}/masters`))
  const menuItems = getMenuItems(currentUserType, basePath)
  const masterItems = getMasterItems(basePath)

  const isActive = (href: string) => {
    // basePath は完全一致でチェック（他のサブパスと区別するため）
    if (href === basePath) {
      return pathname === basePath
    }
    return pathname.startsWith(href)
  }

  const isMasterActive = pathname.startsWith(`${basePath}/masters`)

  return (
    <aside className="w-64 bg-[#1e1e1e] text-white min-h-screen fixed left-0 top-0 border-r border-[#2d2d2d]">
      <div className="p-5">
        <h1 className="text-xl font-semibold mb-8 px-3 text-gray-200">管理画面</h1>
        <nav>
          <ul className="space-y-1">
            {menuItems.map((item) => (
              <li key={item.href}>
                <Link
                  href={item.href}
                  className={`block px-4 py-2.5 text-sm transition-colors rounded ${
                    isActive(item.href)
                      ? 'bg-[#2271b1] text-white font-medium'
                      : 'text-gray-300 hover:bg-[#2d2d2d] hover:text-white'
                  }`}
                >
                  {item.label}
                </Link>
              </li>
            ))}

            {/* Master Management with Submenu (Admin only) */}
            {currentUserType === 'admin' && (
            <li>
              <button
                onClick={() => setIsMasterExpanded(!isMasterExpanded)}
                className={`w-full flex items-center justify-between px-4 py-2.5 text-sm transition-colors rounded ${
                  isMasterActive
                    ? 'bg-[#2271b1] text-white font-medium'
                    : 'text-gray-300 hover:bg-[#2d2d2d] hover:text-white'
                }`}
              >
                <span>マスタ管理</span>
                <span className="text-xs">{isMasterExpanded ? '▼' : '▲'}</span>
              </button>

              {isMasterExpanded && (
                <ul className="mt-1 ml-4 space-y-1">
                  {masterItems.map((item) => (
                    <li key={item.href}>
                      <Link
                        href={item.href}
                        className={`block px-4 py-2 text-sm transition-colors rounded ${
                          pathname === item.href
                            ? 'bg-[#135e96] text-white font-medium'
                            : 'text-gray-400 hover:bg-[#2d2d2d] hover:text-white'
                        }`}
                      >
                        {item.label}
                      </Link>
                    </li>
                  ))}
                </ul>
              )}
            </li>
            )}
          </ul>
        </nav>
      </div>
    </aside>
  )
}
