'use client'

import { useState } from 'react'
import AdminSidebar from './AdminSidebar'
import AdminHeader from './AdminHeader'
import { ServiceCode } from '@/lib/constants/services'

interface ManagementShellProps {
  children: React.ReactNode
  currentUserType: 'admin' | 'user'
  basePath: '/management' | '/admin-management'
  visibleServiceCodes?: ServiceCode[]
}

export default function ManagementShell({
  children,
  currentUserType,
  basePath,
  visibleServiceCodes,
}: ManagementShellProps) {
  const [isSidebarOpen, setIsSidebarOpen] = useState(false)

  return (
    <div className="flex min-h-screen bg-[#f0f0f1]">
      {/* モバイル用オーバーレイ */}
      {isSidebarOpen && (
        <div
          className="fixed inset-0 bg-black/50 z-30 md:hidden"
          onClick={() => setIsSidebarOpen(false)}
        />
      )}
      <AdminSidebar
        currentUserType={currentUserType}
        basePath={basePath}
        isOpen={isSidebarOpen}
        onClose={() => setIsSidebarOpen(false)}
      />
      <div className="flex-1 md:ml-64 min-w-0">
        <AdminHeader
          visibleServiceCodes={visibleServiceCodes}
          onMenuClick={() => setIsSidebarOpen(true)}
        />
        <main className="p-4 md:p-6">
          {children}
        </main>
      </div>
    </div>
  )
}
