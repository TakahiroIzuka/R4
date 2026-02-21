'use client'

import { usePathname } from 'next/navigation'
import { useServiceCode } from '@/contexts/ServiceContext'
import Header from '@/components/Header'
import Footer from '@/components/Footer'
import Breadcrumb from '@/components/Breadcrumb'

export default function ListLayout({
  children,
}: {
  children: React.ReactNode
}) {
  const pathname = usePathname()
  const serviceCode = useServiceCode()
  const isListPage = pathname === `/${serviceCode}/list`

  if (!isListPage) {
    return <>{children}</>
  }

  return (
    <>
      <Header
        pageType="list"
      />
      <Breadcrumb
        items={[
          { label: 'トップ', href: `/${serviceCode}` },
          { label: '施設はこちら' }
        ]}
      />
      {children}
      <Footer pageType="list" />
    </>
  )
}
