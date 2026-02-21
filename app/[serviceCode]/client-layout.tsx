'use client'

import { usePathname } from 'next/navigation'
import Header from '@/components/Header'
import Footer from '@/components/Footer'
import MarqueeText from '@/components/MarqueeText'
import { ServiceProvider } from '@/contexts/ServiceContext'
import { ServiceCode } from '@/lib/constants/services'

interface ClientLayoutProps {
  serviceCode: string
  serviceName: string
  children: React.ReactNode
}

export default function ClientLayout({ serviceCode, serviceName, children }: ClientLayoutProps) {
  const pathname = usePathname()
  const isTopPage = pathname === `/${serviceCode}`

  return (
    <ServiceProvider serviceCode={serviceCode as ServiceCode} serviceName={serviceName}>
      {isTopPage && (
        <>
          <Header />
          <div className="hidden md:block md:mt-0">
            <MarqueeText />
          </div>
        </>
      )}
      {children}
      {isTopPage && (
        <Footer />
      )}
    </ServiceProvider>
  )
}
